//
//  ThinkFirstApp.swift
//  ThinkFirst
//
//  Created by Ahmad Rasheed on 1/16/26.
//

import SwiftUI

@main
struct ThinkFirstApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var userProgress: UserProgress = .empty
    @Published var hasCompletedOnboarding: Bool = false
    @Published var showBadgeUnlock: Badge?
    @Published var showLimitReached: Bool = false
    @Published var showMercyModal: Bool = false
    @Published var currentQuestion: Question?
    @Published var currentEvaluation: Evaluation?
    
    init() {
        loadUserData()
    }
    
    func loadUserData() {
        currentUser = StorageService.shared.getCurrentUser()
        userProgress = StorageService.shared.getProgress()
        hasCompletedOnboarding = StorageService.shared.hasCompletedOnboarding()
    }
    
    func saveUser(_ user: User) {
        currentUser = user
        StorageService.shared.saveUser(user)
    }
    
    func updateProgress(_ progress: UserProgress) {
        userProgress = progress
        StorageService.shared.saveProgress(progress)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        StorageService.shared.setOnboardingCompleted(true)
    }
    
    func logout() {
        currentUser = nil
        userProgress = .empty
        hasCompletedOnboarding = false
        StorageService.shared.clearUser()
    }
    
    var isPremium: Bool {
        currentUser?.isPremium ?? false
    }
    
    var isStudent: Bool {
        currentUser?.type == .student
    }
    
    var isParent: Bool {
        currentUser?.type == .parent
    }
}
