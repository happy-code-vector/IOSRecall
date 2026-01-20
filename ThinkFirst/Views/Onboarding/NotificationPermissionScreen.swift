//
//  NotificationPermissionScreen.swift
//  ThinkFirst
//
//  Requests notification permission to protect learning streaks
//

import SwiftUI
import UserNotifications

struct NotificationPermissionScreen: View {
    let onContinue: () -> Void
    
    @State private var animateBell = false
    
    var body: some View {
        VStack(spacing: 48) {
            Spacer()
            
            // 3D Bell Icon
            bellIconView
            
            // Headline
            VStack(spacing: 16) {
                Text("Protect Your Streak.")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("We only notify you to keep your learning streak alive. No spam.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                // Enable Notifications - Primary Button
                Button(action: handleEnable) {
                    Text("Enable Notifications")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                        )
                }
                
                // Maybe Later - Text Button
                Button(action: onContinue) {
                    Text("Maybe Later")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
            .padding(.horizontal, 24)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
        .onAppear {
            animateBell = true
        }
    }
    
    // MARK: - Bell Icon View
    private var bellIconView: some View {
        ZStack {
            // Glow layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.gray.opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 128, height: 128)
                .scaleEffect(animateBell ? 1.1 : 1.0)
                .opacity(animateBell ? 0.7 : 0.5)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateBell)
            
            // Shadow layer
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.gray.opacity(0.6), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 96, height: 96)
                .blur(radius: 12)
                .opacity(0.4)
                .offset(y: 8)
            
            // Main bell with chrome effect
            ZStack {
                // Bell background with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.23, green: 0.23, blue: 0.29),
                                Color(red: 0.16, green: 0.16, blue: 0.22),
                                Color(red: 0.10, green: 0.10, blue: 0.16)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)
                    .shadow(color: .black.opacity(0.6), radius: 15, x: 0, y: 10)
                    .overlay(
                        // Inner shadow
                        Circle()
                            .stroke(Color.black.opacity(0.5), lineWidth: 1)
                            .blur(radius: 1)
                            .offset(y: 1)
                    )
                    .overlay(
                        // Highlight reflection
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.4), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .center
                                )
                            )
                            .frame(width: 80, height: 32)
                            .offset(y: -16)
                            .opacity(0.3)
                    )
                
                // Bell icon
                Image(systemName: "bell")
                    .font(.system(size: 48, weight: .regular))
                    .foregroundColor(Color(red: 0.91, green: 0.91, blue: 0.94))
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            }
            .offset(y: animateBell ? -8 : 0)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateBell)
        }
    }
    
    // MARK: - Actions
    private func handleEnable() {
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Notification permission granted")
                } else {
                    print("Notification permission denied")
                }
                onContinue()
            }
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

#Preview {
    NotificationPermissionScreen(onContinue: {})
}