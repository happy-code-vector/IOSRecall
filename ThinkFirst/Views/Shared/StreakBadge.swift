//
//  StreakBadge.swift
//  ThinkFirst
//
//  Streak counter badge with fire emoji
//

import SwiftUI

struct StreakBadge: View {
    let count: Int
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 6) {
            Text("🔥")
                .font(.system(size: 20))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: 0.35)
                    .repeatCount(1, autoreverses: true),
                    value: isAnimating
                )
            
            Text("\(count)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(ThinkFirstTheme.Colors.surfaceGlass)
                .overlay(
                    Capsule()
                        .stroke(ThinkFirstTheme.Colors.safetyOrange.opacity(0.3), lineWidth: 1)
                )
        )
        .onChange(of: count) { oldValue, newValue in
            if newValue > oldValue {
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    isAnimating = false
                }
            }
        }
    }
}

#Preview {
    ZStack {
        ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
        
        StreakBadge(count: 7)
    }
}
