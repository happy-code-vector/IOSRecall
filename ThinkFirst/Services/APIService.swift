//
//  APIService.swift
//  ThinkFirst
//
//  API service for backend communication
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(String)
}

class APIService {
    static let shared = APIService()
    
    // TODO: Replace with actual Supabase URL
    private let baseURL = "https://your-project.supabase.co/functions/v1"
    private let apiKey = "your-supabase-anon-key"
    
    private init() {}
    
    // MARK: - Evaluation
    func evaluateAttempt(
        question: String,
        attempt: String,
        userId: String,
        masteryMode: Bool,
        gradeLevel: String
    ) async throws -> Evaluation {
        let endpoint = "\(baseURL)/evaluate"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let requestBody = AttemptRequest(
            question: question,
            attempt: attempt,
            userId: userId,
            masteryMode: masteryMode,
            gradeLevel: gradeLevel
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError("Status code: \(httpResponse.statusCode)")
            }
            
            let evaluationResponse = try JSONDecoder().decode(EvaluationResponse.self, from: data)
            
            return Evaluation(
                effortScore: evaluationResponse.effortScore,
                understandingScore: evaluationResponse.understandingScore,
                copied: evaluationResponse.copied,
                whatIsRight: evaluationResponse.whatIsRight,
                whatIsMissing: evaluationResponse.whatIsMissing,
                unlock: evaluationResponse.unlock,
                fullExplanation: evaluationResponse.fullExplanation,
                coachHint: evaluationResponse.coachHint,
                levelUpTip: evaluationResponse.levelUpTip
            )
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Streak
    func getStreak(userId: String) async throws -> (count: Int, lastDate: Date?) {
        let endpoint = "\(baseURL)/streak/\(userId)"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct StreakResponse: Codable {
            let count: Int
            let lastDate: String?
        }
        
        let response = try JSONDecoder().decode(StreakResponse.self, from: data)
        
        let dateFormatter = ISO8601DateFormatter()
        let lastDate = response.lastDate.flatMap { dateFormatter.date(from: $0) }
        
        return (response.count, lastDate)
    }
    
    func incrementStreak(userId: String) async throws {
        let endpoint = "\(baseURL)/streak/\(userId)/increment"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Badges
    func checkBadges(userId: String) async throws -> [String] {
        let endpoint = "\(baseURL)/badges/\(userId)/check"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct BadgeResponse: Codable {
            let newBadges: [String]
        }
        
        let response = try JSONDecoder().decode(BadgeResponse.self, from: data)
        return response.newBadges
    }
    
    // MARK: - Family
    func generateInviteCode(parentUserId: String) async throws -> String {
        let endpoint = "\(baseURL)/family/generate-invite"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let body = ["parentUserId": parentUserId]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct InviteResponse: Codable {
            let inviteCode: String
        }
        
        let response = try JSONDecoder().decode(InviteResponse.self, from: data)
        return response.inviteCode
    }
    
    func connectStudent(studentUserId: String, inviteCode: String, studentName: String) async throws -> String {
        let endpoint = "\(baseURL)/family/connect-student"
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let body = [
            "studentUserId": studentUserId,
            "inviteCode": inviteCode,
            "studentName": studentName
        ]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        struct ConnectResponse: Codable {
            let success: Bool
            let parentUserId: String
        }
        
        let response = try JSONDecoder().decode(ConnectResponse.self, from: data)
        return response.parentUserId
    }
}
