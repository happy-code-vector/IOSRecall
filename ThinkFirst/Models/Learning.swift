//
//  Learning.swift
//  ThinkFirst
//
//  Models for the learning loop
//

import Foundation

struct Question: Codable, Identifiable {
    let id: String
    let text: String
    let timestamp: Date
    var attempt: String?
    var evaluation: Evaluation?
    
    init(id: String = UUID().uuidString, text: String, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
    }
}

struct Evaluation: Codable {
    let effortScore: Int
    let understandingScore: Int
    let copied: Bool
    let whatIsRight: String
    let whatIsMissing: String
    let unlock: Bool
    let fullExplanation: String?
    let coachHint: String?
    let levelUpTip: String?
    
    var totalScore: Int {
        effortScore + understandingScore
    }
    
    var canUnlock: Bool {
        totalScore >= 12
    }
}

struct AttemptRequest: Codable {
    let question: String
    let attempt: String
    let userId: String
    let masteryMode: Bool
    let gradeLevel: String
}

struct EvaluationResponse: Codable {
    let effortScore: Int
    let understandingScore: Int
    let copied: Bool
    let whatIsRight: String
    let whatIsMissing: String
    let unlock: Bool
    let fullExplanation: String?
    let coachHint: String?
    let levelUpTip: String?
    
    enum CodingKeys: String, CodingKey {
        case effortScore = "effort_score"
        case understandingScore = "understanding_score"
        case copied
        case whatIsRight = "what_is_right"
        case whatIsMissing = "what_is_missing"
        case unlock
        case fullExplanation = "full_explanation"
        case coachHint = "coach_hint"
        case levelUpTip = "level_up_tip"
    }
}

enum MasteryMode {
    case standard
    case mastery
    
    var multiplier: Int {
        switch self {
        case .standard: return 1
        case .mastery: return 2
        }
    }
}
