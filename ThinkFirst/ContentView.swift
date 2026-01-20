//
//  ContentView.swift
//  ThinkFirst
//
//  Root navigation controller
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingFlow()
            } else if appState.currentUser == nil {
                LoginScreen()
            } else {
                MainAppView()
            }
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

// MARK: - Main App View
struct MainAppView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            Group {
                switch appState.currentScreen {
                case .home:
                    HomeScreen()
                case .attemptGate:
                    if let question = appState.currentQuestion {
                        AttemptGate(
                            question: question,
                            onSubmit: appState.submitAttempt,
                            onBack: appState.goHome,
                            previousAttempt: appState.currentAttempt.isEmpty ? nil : appState.currentAttempt,
                            coachHint: appState.currentEvaluation?.coachHint,
                            onRevealAnswer: appState.unlockAnswer
                        )
                    } else {
                        HomeScreen()
                    }
                case .evaluation:
                    if let question = appState.currentQuestion {
                        EvaluationScreen(
                            question: question,
                            attempt: appState.currentAttempt,
                            evaluation: appState.currentEvaluation,
                            isLoading: appState.isLoading,
                            isRevisionMode: false,
                            onUnlock: appState.unlockAnswer,
                            onRetry: appState.retryAttempt,
                            onHome: appState.goHome
                        )
                    } else {
                        HomeScreen()
                    }
                case .answer:
                    AnswerScreen(
                        question: appState.currentQuestion?.text ?? "",
                        evaluation: appState.currentEvaluation,
                        onHome: appState.goHome
                    )
                default:
                    HomeScreen()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Welcome to ThinkFirst")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Sign in to save your progress")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                // For now, just a simple continue button
                // In a real app, this would have proper authentication
                Button(action: {
                    // Create a default user for demo purposes
                    let user = User(
                        id: UUID().uuidString,
                        name: "Demo User",
                        email: "demo@thinkfirst.com",
                        type: .student,
                        gradeLevel: .highSchool,
                        subscriptionTier: .free,
                        avatarURL: nil,
                        familyId: nil,
                        createdAt: Date()
                    )
                    appState.setCurrentUser(user)
                }) {
                    Text("Continue as Demo User")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .padding(.horizontal, 24)
            }
            
            Spacer()
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
