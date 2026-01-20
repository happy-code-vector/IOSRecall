//
//  StorageService.swift
//  ThinkFirst
//
//  Local storage service using UserDefaults and Keychain
//

import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let currentUser = "thinkfirst_currentUser"
        static let userProgress = "thinkfirst_userProgress"
        static let userGrade = "thinkfirst_userGrade"
        static let questionHistory = "thinkfirst_questionHistory"
        static let dailyQuestionCount = "thinkfirst_dailyQuestionCount"
        static let lastQuestionDate = "thinkfirst_lastQuestionDate"
        static let hasCompletedOnboarding = "thinkfirst_hasCompletedOnboarding"
        static let guardianPin = "thinkfirst_guardianPin"
        static let guardianSettings = "thinkfirst_guardianSettings"
    }
    
    // MARK: - User
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: Keys.currentUser)
        }
    }
    
    func getCurrentUser() -> User? {
        guard let data = defaults.data(forKey: Keys.currentUser),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearUser() {
        defaults.removeObject(forKey: Keys.currentUser)
    }
    
    // MARK: - Progress
    func saveProgress(_ progress: UserProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            defaults.set(encoded, forKey: Keys.userProgress)
        }
    }
    
    func getProgress() -> UserProgress {
        guard let data = defaults.data(forKey: Keys.userProgress),
              let progress = try? JSONDecoder().decode(UserProgress.self, from: data) else {
            return .empty
        }
        return progress
    }
    
    // MARK: - Grade Level
    func saveGradeLevel(_ grade: GradeLevel) {
        defaults.set(grade.rawValue, forKey: Keys.userGrade)
    }
    
    func getGradeLevel() -> GradeLevel? {
        guard let gradeString = defaults.string(forKey: Keys.userGrade) else {
            return nil
        }
        return GradeLevel(rawValue: gradeString)
    }
    
    // MARK: - Question History
    func saveQuestionHistory(_ questions: [Question]) {
        if let encoded = try? JSONEncoder().encode(questions) {
            defaults.set(encoded, forKey: Keys.questionHistory)
        }
    }
    
    func getQuestionHistory() -> [Question] {
        guard let data = defaults.data(forKey: Keys.questionHistory),
              let questions = try? JSONDecoder().decode([Question].self, from: data) else {
            return []
        }
        return questions
    }
    
    func addQuestion(_ question: Question) {
        var history = getQuestionHistory()
        history.insert(question, at: 0)
        saveQuestionHistory(history)
    }
    
    // MARK: - Daily Question Limit
    func getDailyQuestionCount() -> Int {
        let lastDate = defaults.object(forKey: Keys.lastQuestionDate) as? Date ?? Date.distantPast
        let calendar = Calendar.current
        
        if calendar.isDateInToday(lastDate) {
            return defaults.integer(forKey: Keys.dailyQuestionCount)
        } else {
            return 0
        }
    }
    
    func incrementDailyQuestionCount() {
        let count = getDailyQuestionCount()
        defaults.set(count + 1, forKey: Keys.dailyQuestionCount)
        defaults.set(Date(), forKey: Keys.lastQuestionDate)
    }
    
    func resetDailyQuestionCount() {
        defaults.set(0, forKey: Keys.dailyQuestionCount)
        defaults.set(Date(), forKey: Keys.lastQuestionDate)
    }
    
    // MARK: - Onboarding
    func setOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: Keys.hasCompletedOnboarding)
    }
    
    func hasCompletedOnboarding() -> Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }
    
    // MARK: - Guardian Settings
    func saveGuardianSettings(_ settings: GuardianSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: Keys.guardianSettings)
        }
    }
    
    func getGuardianSettings() -> GuardianSettings {
        guard let data = defaults.data(forKey: Keys.guardianSettings),
              let settings = try? JSONDecoder().decode(GuardianSettings.self, from: data) else {
            return .default
        }
        return settings
    }
    
    func saveGuardianPin(_ pin: String) {
        defaults.set(pin, forKey: Keys.guardianPin)
    }
    
    func getGuardianPin() -> String? {
        defaults.string(forKey: Keys.guardianPin)
    }
    
    func hasGuardianPin() -> Bool {
        getGuardianPin() != nil
    }
    
    // MARK: - Generic Storage Methods
    func setBool(_ value: Bool, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getBool(for key: String) -> Bool? {
        guard defaults.object(forKey: key) != nil else { return nil }
        return defaults.bool(forKey: key)
    }
    
    func setInt(_ value: Int, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getInt(for key: String) -> Int? {
        guard defaults.object(forKey: key) != nil else { return nil }
        return defaults.integer(forKey: key)
    }
    
    func setData(_ data: Data, for key: String) {
        defaults.set(data, forKey: key)
    }
    
    func getData(for key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
    func removeValue(for key: String) {
        defaults.removeObject(forKey: key)
    }
}
