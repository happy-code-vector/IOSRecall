//
//  BottomNav.swift
//  ThinkFirst
//
//  Bottom navigation bar for main app screens
//

import SwiftUI

struct BottomNav: View {
    let currentTab: String
    let onGoToHome: () -> Void
    let onGoToProgress: () -> Void
    let onGoToHistory: () -> Void
    let onGoToTechniques: (() -> Void)?
    let streak: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                // Home
                BottomNavItem(
                    icon: "house",
                    title: "Home",
                    isActive: currentTab == "home",
                    action: onGoToHome
                )
                
                // Progress
                BottomNavItem(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Progress",
                    isActive: currentTab == "progress",
                    action: onGoToProgress
                )
                
                // History
                BottomNavItem(
                    icon: "clock",
                    title: "History",
                    isActive: currentTab == "history",
                    action: onGoToHistory
                )
                
                // Techniques (if available)
                if let onGoToTechniques = onGoToTechniques {
                    BottomNavItem(
                        icon: "lightbulb",
                        title: "Tips",
                        isActive: currentTab == "techniques",
                        action: onGoToTechniques
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 34)
        }
    }
}

struct BottomNavItem: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isActive ? ThinkFirstTheme.Colors.electricViolet : .gray)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isActive ? ThinkFirstTheme.Colors.electricViolet : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .scaleEffect(1.0)
        .animation(.easeOut(duration: 0.08), value: isActive)
    }
}

#Preview {
    ZStack {
        ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
        
        BottomNav(
            currentTab: "home",
            onGoToHome: {},
            onGoToProgress: {},
            onGoToHistory: {},
            onGoToTechniques: {},
            streak: 5
        )
    }
}