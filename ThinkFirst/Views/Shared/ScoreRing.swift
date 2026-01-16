//
//  ScoreRing.swift
//  ThinkFirst
//
//  Circular progress ring for scores
//

import SwiftUI

struct ScoreRing: View {
    let score: Int
    let maxScore: Int
    let color: Color
    let label: String
    
    @State private var animatedScore: Double = 0
    
    private var progress: Double {
        Double(score) / Double(maxScore)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: animatedScore)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.6), value: animatedScore)
                
                // Score text
                VStack(spacing: 2) {
                    Text("\(Int(animatedScore * Double(maxScore)))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
                    
                    Text("/\(maxScore)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
                }
            }
            
            Text(label)
                .font(ThinkFirstTheme.Typography.subheadline)
                .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                animatedScore = progress
            }
        }
    }
}

#Preview {
    ZStack {
        ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
        
        HStack(spacing: 40) {
            ScoreRing(
                score: 8,
                maxScore: 10,
                color: ThinkFirstTheme.Colors.electricViolet,
                label: "Effort"
            )
            
            ScoreRing(
                score: 7,
                maxScore: 10,
                color: ThinkFirstTheme.Colors.cyan,
                label: "Understanding"
            )
        }
    }
}
