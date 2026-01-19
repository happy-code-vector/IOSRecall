//
//  MethodologyScreen.swift
//  ThinkFirst
//
//  Explains the ThinkFirst methodology
//

import SwiftUI

struct MethodologyScreen: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("How ThinkFirst Works")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Our proven 3-step process")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 24) {
                MethodologyStep(
                    number: "1",
                    title: "Think First",
                    description: "Attempt the question before seeing any answers",
                    icon: "brain"
                )
                
                MethodologyStep(
                    number: "2",
                    title: "Get Feedback",
                    description: "Receive personalized evaluation and guidance",
                    icon: "checkmark.circle"
                )
                
                MethodologyStep(
                    number: "3",
                    title: "Unlock Content",
                    description: "Access explanations and build understanding",
                    icon: "key.fill"
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton(
                title: "Got it!",
                isEnabled: true,
                action: onContinue
            )
            .padding(.horizontal)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

struct MethodologyStep: View {
    let number: String
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ThinkFirstTheme.Colors.electricViolet)
                    .frame(width: 40, height: 40)
                
                Text(number)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}

#Preview {
    MethodologyScreen(onContinue: {})
}