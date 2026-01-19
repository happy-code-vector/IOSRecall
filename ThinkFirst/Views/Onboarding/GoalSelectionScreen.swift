//
//  GoalSelectionScreen.swift
//  ThinkFirst
//
//  Goal selection for onboarding
//

import SwiftUI

struct GoalSelectionScreen: View {
    let userType: UserType
    @Binding var selectedGoal: String?
    let onContinue: () -> Void
    
    private var goals: [String] {
        switch userType {
        case .student:
            return [
                "Improve critical thinking",
                "Better problem solving",
                "Academic success",
                "Build confidence",
                "Develop reasoning skills"
            ]
        case .parent:
            return [
                "Help my child think critically",
                "Support academic growth",
                "Build problem-solving skills",
                "Encourage independent thinking",
                "Track learning progress"
            ]
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("What's your main goal?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We'll personalize your experience")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                ForEach(goals, id: \.self) { goal in
                    Button(action: {
                        selectedGoal = goal
                    }) {
                        HStack {
                            Text(goal)
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            if selectedGoal == goal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedGoal == goal ? 
                                      ThinkFirstTheme.Colors.electricViolet.opacity(0.2) : 
                                      Color.gray.opacity(0.1))
                                .stroke(selectedGoal == goal ? 
                                       ThinkFirstTheme.Colors.electricViolet : 
                                       Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton(
                title: "Continue",
                isEnabled: selectedGoal != nil,
                action: onContinue
            )
            .padding(.horizontal)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

#Preview {
    GoalSelectionScreen(
        userType: .student,
        selectedGoal: .constant("Improve critical thinking"),
        onContinue: {}
    )
}