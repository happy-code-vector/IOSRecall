//
//  OnboardingFlow.swift
//  ThinkFirst
//
//  Onboarding flow coordinator
//

import SwiftUI

struct OnboardingFlow: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var selectedUserType: UserType?
    @State private var selectedGrade: GradeLevel?
    @State private var selectedGoal: String?
    
    var body: some View {
        ZStack {
            ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
            
            Group {
                switch currentStep {
                case 0:
                    SplashScreen(onContinue: { currentStep = 1 })
                case 1:
                    AccountTypeScreen(
                        selectedType: $selectedUserType,
                        onContinue: {
                            currentStep = 2
                        }
                    )
                case 2:
                    if selectedUserType == .student {
                        GradeSelectionScreen(
                            selectedGrade: $selectedGrade,
                            onContinue: { currentStep = 3 }
                        )
                    } else {
                        // Skip grade for parents
                        GoalSelectionScreen(
                            userType: selectedUserType ?? .parent,
                            selectedGoal: $selectedGoal,
                            onContinue: { currentStep = 3 }
                        )
                        .onAppear {
                            currentStep = 3
                        }
                    }
                case 3:
                    GoalSelectionScreen(
                        userType: selectedUserType ?? .student,
                        selectedGoal: $selectedGoal,
                        onContinue: { currentStep = 4 }
                    )
                case 4:
                    MethodologyScreen(onContinue: { currentStep = 5 })
                case 5:
                    TryItDemoScreen(onContinue: { currentStep = 6 })
                case 6:
                    NotificationPermissionScreen(onContinue: { currentStep = 7 })
                case 7:
                    LoginScreen(
                        onComplete: {
                            completeOnboarding()
                        }
                    )
                default:
                    EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
        }
        .animation(.easeInOut(duration: ThinkFirstTheme.Animation.standard), value: currentStep)
    }
    
    private func completeOnboarding() {
        // Create user
        let user = User(
            id: UUID().uuidString,
            name: "User",
            email: nil,
            type: selectedUserType ?? .student,
            gradeLevel: selectedGrade,
            subscriptionTier: .free,
            avatarURL: nil,
            familyId: nil,
            createdAt: Date()
        )
        
        appState.setCurrentUser(user)
        appState.completeOnboarding()
    }
}
