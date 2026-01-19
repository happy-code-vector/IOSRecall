//
//  NotificationPermissionScreen.swift
//  ThinkFirst
//
//  Requests notification permissions
//

import SwiftUI
import UserNotifications

struct NotificationPermissionScreen: View {
    let onContinue: () -> Void
    @State private var permissionRequested = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 60))
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                
                Text("Stay on Track")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Get gentle reminders to keep your thinking streak alive")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 16) {
                NotificationBenefit(
                    icon: "flame.fill",
                    title: "Streak Reminders",
                    description: "Don't break your thinking streak"
                )
                
                NotificationBenefit(
                    icon: "star.fill",
                    title: "Achievement Alerts",
                    description: "Celebrate when you unlock new badges"
                )
                
                NotificationBenefit(
                    icon: "clock.fill",
                    title: "Perfect Timing",
                    description: "Notifications when you're most likely to engage"
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(
                    title: "Enable Notifications",
                    isEnabled: true,
                    action: requestNotificationPermission
                )
                
                Button("Maybe Later") {
                    onContinue()
                }
                .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                permissionRequested = true
                onContinue()
            }
        }
    }
}

struct NotificationBenefit: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                .frame(width: 30)
            
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
        }
    }
}

#Preview {
    NotificationPermissionScreen(onContinue: {})
}