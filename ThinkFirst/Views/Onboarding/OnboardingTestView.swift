//
//  OnboardingTestView.swift
//  ThinkFirst
//
//  Test view to verify onboarding screens work correctly
//

import SwiftUI

struct OnboardingTestView: View {
    @State private var currentScreen = 0
    
    var body: some View {
        ZStack {
            ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
            
            VStack {
                // Screen selector
                HStack {
                    Button("TryIt Demo") {
                        currentScreen = 0
                    }
                    .foregroundColor(currentScreen == 0 ? .white : .gray)
                    
                    Button("Notifications") {
                        currentScreen = 1
                    }
                    .foregroundColor(currentScreen == 1 ? .white : .gray)
                }
                .padding()
                
                // Screen content
                Group {
                    if currentScreen == 0 {
                        TryItDemoScreen(onContinue: {
                            print("TryItDemo completed")
                        })
                    } else {
                        NotificationPermissionScreen(onContinue: {
                            print("Notifications completed")
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingTestView()
}