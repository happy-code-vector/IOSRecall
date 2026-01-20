//
//  AppState.swift
//  ThinkFirst
//
//  Global app state management
//

import SwiftUI
import Combine

enum AppScreen {
    case onboarding
    case login
    case home
    case attemptGate
    case evaluation
    case answer
    case progress
    case history
    case badges
    case profile
    case pricing
    case techniques
}

class AppState: ObservableObject {
    // MARK: - Published Properties
    @Published var hasCompletedOnboarding = false
    @Published var currentUser: User?
    @Published var currentScreen: AppScreen = .home
    @Published var currentQuestion: Question?
    @Published var currentAttempt: String = ""
    @Published var currentEvaluation: Evaluation?
    @Published var isLoading = false
    
    // Learning state
    @Published var learningHistory: [Question] = []
    @Published var questionsToday = 0
    @Published var streak = 0
    @Published var totalXP = 0
    @Published var level = 1
    @Published var badges: [Badge] = []
    
    // Family state
    @Published var familyMembers: [User] = []
    @Published var familyStreak = 0
    
    // Subscription state
    @Published var subscriptionTier: SubscriptionTier = .free
    @Published var isPremium = false
    
    // Services
    private let apiService = APIService.shared
    private let storageService = StorageService.shared
    
    // MARK: - Computed Properties
    var isStudent: Bool {
        currentUser?.type == .student
    }
    
    var isParent: Bool {
        currentUser?.type == .parent
    }
    
    var canAskQuestions: Bool {
        isPremium || questionsToday < 3
    }
    
    var canUnlockAnswers: Bool {
        isPremium || questionsToday < 5
    }
    
    // MARK: - Initialization
    init() {
        loadUserData()
    }
    
    // MARK: - User Management
    func setCurrentUser(_ user: User) {
        currentUser = user
        isPremium = user.subscriptionTier != .free
        subscriptionTier = user.subscriptionTier
        saveUserData()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveUserData()
    }
    
    func logout() {
        currentUser = nil
        hasCompletedOnboarding = false
        isPremium = false
        subscriptionTier = .free
        currentScreen = .onboarding
        clearUserData()
    }
    
    // MARK: - Learning Flow
    func startQuestion(_ question: String) {
        currentQuestion = Question(text: question)
        currentAttempt = ""
        currentEvaluation = nil
        currentScreen = .attemptGate
    }
    
    func submitAttempt(_ attempt: String, masteryMode: Bool) {
        guard let question = currentQuestion else { return }
        
        currentAttempt = attempt
        isLoading = true
        currentScreen = .evaluation
        
        // Simulate API call
        Task {
            do {
                let evaluation = try await apiService.evaluateAttempt(
                    question: question.text,
                    attempt: attempt,
                    masteryMode: masteryMode
                )
                
                await MainActor.run {
                    self.currentEvaluation = evaluation
                    self.isLoading = false
                    
                    // Update progress
                    if evaluation.unlock {
                        self.questionsToday += 1
                        self.totalXP += masteryMode ? evaluation.totalScore * 2 : evaluation.totalScore
                        self.updateLevel()
                        self.updateStreak()
                    }
                    
                    // Save to history
                    var updatedQuestion = question
                    updatedQuestion.attempt = attempt
                    updatedQuestion.evaluation = evaluation
                    self.learningHistory.append(updatedQuestion)
                    self.saveUserData()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    // Handle error
                }
            }
        }
    }
    
    func unlockAnswer() {
        currentScreen = .answer
    }
    
    func retryAttempt() {
        currentScreen = .attemptGate
    }
    
    func goHome() {
        currentScreen = .home
        currentQuestion = nil
        currentAttempt = ""
        currentEvaluation = nil
    }
    
    // MARK: - Progress Management
    private func updateLevel() {
        let newLevel = (totalXP / 1000) + 1
        if newLevel > level {
            level = newLevel
            // Could trigger level up celebration
        }
    }
    
    private func updateStreak() {
        // Simple streak logic - would be more complex in real app
        let today = Calendar.current.startOfDay(for: Date())
        let lastQuestionDate = learningHistory.last?.timestamp ?? Date.distantPast
        let lastQuestionDay = Calendar.current.startOfDay(for: lastQuestionDate)
        
        if Calendar.current.isDate(today, equalTo: lastQuestionDay, toGranularity: .day) {
            // Same day, maintain streak
        } else if Calendar.current.dateInterval(of: .day, for: today)?.start == Calendar.current.date(byAdding: .day, value: 1, to: lastQuestionDay) {
            // Next day, increment streak
            streak += 1
        } else {
            // Streak broken
            streak = 1
        }
    }
    
    // MARK: - Navigation
    func navigateTo(_ screen: AppScreen) {
        currentScreen = screen
    }
    
    // MARK: - Data Persistence
    private func loadUserData() {
        hasCompletedOnboarding = storageService.getBool(for: "hasCompletedOnboarding") ?? false
        
        if let userData = storageService.getData(for: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            setCurrentUser(user)
        }
        
        if let historyData = storageService.getData(for: "learningHistory"),
           let history = try? JSONDecoder().decode([Question].self, from: historyData) {
            learningHistory = history
        }
        
        questionsToday = storageService.getInt(for: "questionsToday") ?? 0
        streak = storageService.getInt(for: "streak") ?? 0
        totalXP = storageService.getInt(for: "totalXP") ?? 0
        level = storageService.getInt(for: "level") ?? 1
    }
    
    private func saveUserData() {
        storageService.setBool(hasCompletedOnboarding, for: "hasCompletedOnboarding")
        
        if let user = currentUser,
           let userData = try? JSONEncoder().encode(user) {
            storageService.setData(userData, for: "currentUser")
        }
        
        if let historyData = try? JSONEncoder().encode(learningHistory) {
            storageService.setData(historyData, for: "learningHistory")
        }
        
        storageService.setInt(questionsToday, for: "questionsToday")
        storageService.setInt(streak, for: "streak")
        storageService.setInt(totalXP, for: "totalXP")
        storageService.setInt(level, for: "level")
    }
    
    private func clearUserData() {
        storageService.removeValue(for: "hasCompletedOnboarding")
        storageService.removeValue(for: "currentUser")
        storageService.removeValue(for: "learningHistory")
        storageService.removeValue(for: "questionsToday")
        storageService.removeValue(for: "streak")
        storageService.removeValue(for: "totalXP")
        storageService.removeValue(for: "level")
    }
}