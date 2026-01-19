//
//  TryItDemoScreen.swift
//  ThinkFirst
//
//  Interactive demo of the ThinkFirst process
//

import SwiftUI

struct TryItDemoScreen: View {
    let onContinue: () -> Void
    @State private var currentStep = 0
    @State private var userInput = ""
    
    private let demoQuestion = "What's the most important factor when making a difficult decision?"
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Try It Out")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Experience the ThinkFirst method")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            GlassCard {
                VStack(spacing: 20) {
                    Text(demoQuestion)
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    if currentStep == 0 {
                        VStack(spacing: 16) {
                            TextField("Type your thoughts here...", text: $userInput, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3...6)
                            
                            Button("Submit Answer") {
                                currentStep = 1
                            }
                            .disabled(userInput.isEmpty)
                            .foregroundColor(userInput.isEmpty ? .gray : ThinkFirstTheme.Colors.electricViolet)
                        }
                    } else if currentStep == 1 {
                        VStack(spacing: 16) {
                            Text("Great thinking! 🎉")
                                .font(.headline)
                                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                            
                            Text("You considered multiple perspectives and showed good reasoning. This is exactly what ThinkFirst helps you develop!")
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Button("See Full Explanation") {
                                currentStep = 2
                            }
                            .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                        }
                    } else {
                        VStack(spacing: 16) {
                            Text("🔓 Content Unlocked!")
                                .font(.headline)
                                .foregroundColor(ThinkFirstTheme.Colors.gold)
                            
                            Text("Decision-making involves weighing pros and cons, considering long-term consequences, and understanding your values. The most important factor is often taking time to think before acting.")
                                .font(.body)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            if currentStep >= 2 {
                PrimaryButton(
                    title: "Continue to App",
                    isEnabled: true,
                    action: onContinue
                )
                .padding(.horizontal)
            }
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

#Preview {
    TryItDemoScreen(onContinue: {})
}