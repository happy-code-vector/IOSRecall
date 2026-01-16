//
//  GlassCard.swift
//  ThinkFirst
//
//  Glassmorphic card component
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    
    init(padding: CGFloat = ThinkFirstTheme.Spacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                    .fill(ThinkFirstTheme.Colors.surfaceGlass)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                            .stroke(ThinkFirstTheme.Colors.glassBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 8)
            )
    }
}

#Preview {
    ZStack {
        ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
        
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Glass Card")
                    .font(ThinkFirstTheme.Typography.title2)
                    .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
                
                Text("This is a glassmorphic card with the Dark Focus aesthetic.")
                    .font(ThinkFirstTheme.Typography.body)
                    .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
            }
        }
        .padding()
    }
}
