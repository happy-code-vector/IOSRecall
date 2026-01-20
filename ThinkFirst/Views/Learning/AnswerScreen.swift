//
//  AnswerScreen.swift
//  ThinkFirst
//
//  Full answer reveal screen matching web version
//

import SwiftUI

struct AnswerScreen: View {
    let question: String
    let evaluation: Evaluation?
    let onHome: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
                
                // Ambient glow
                Circle()
                    .fill(ThinkFirstTheme.Colors.success.opacity(0.2))
                    .frame(width: 600, height: 600)
                    .blur(radius: 150)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header with unlock animation
                        headerView
                            .padding(.top, 56)
                        
                        // Full Explanation
                        if let evaluation = evaluation {
                            explanationView(evaluation: evaluation)
                        }
                        
                        // Follow-up prompts
                        followUpPromptsView
                        
                        // Action buttons
                        actionButtonsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 24)
                }
                .opacity(showContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(0.3), value: showContent)
            }
        }
        .onAppear {
            // Unlock animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 24) {
            // Unlock animation
            ZStack {
                // Glow effect
                Circle()
                    .fill(ThinkFirstTheme.Colors.success.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                
                // Unlock icon
                ZStack {
                    Circle()
                        .fill(ThinkFirstTheme.Colors.success.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "lock.open")
                        .font(.system(size: 32))
                        .foregroundColor(ThinkFirstTheme.Colors.success)
                }
            }
            
            // Title
            VStack(spacing: 8) {
                Text("🎉 Answer Unlocked!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Here's the complete explanation")
                    .font(ThinkFirstTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            // Question
            Text(question)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ThinkFirstTheme.Colors.success.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }
    
    // MARK: - Explanation View
    private func explanationView(evaluation: Evaluation) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section title
            HStack(spacing: 8) {
                Image(systemName: "lightbulb")
                    .font(.system(size: 20))
                    .foregroundColor(.yellow)
                
                Text("Complete Explanation")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Full explanation text
            if let fullExplanation = evaluation.fullExplanation {
                Text(fullExplanation)
                    .font(ThinkFirstTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(nil)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
            } else {
                // Fallback explanation
                Text("This is a comprehensive explanation of the topic. The key concepts include the main principles and how they work together to create the overall understanding.")
                    .font(ThinkFirstTheme.Typography.body)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(nil)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
            }
            
            // Level up tip (if available)
            if let levelUpTip = evaluation.levelUpTip {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "star")
                            .font(.system(size: 16))
                            .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                        
                        Text("Level Up Tip")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                    }
                    
                    Text(levelUpTip)
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ThinkFirstTheme.Colors.electricViolet.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ThinkFirstTheme.Colors.electricViolet.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
    
    // MARK: - Follow-up Prompts
    private var followUpPromptsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 16))
                    .foregroundColor(ThinkFirstTheme.Colors.cyan)
                
                Text("Keep Learning")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ThinkFirstTheme.Colors.cyan)
            }
            
            let followUpQuestions = [
                "What are some real-world applications of this concept?",
                "How does this relate to other topics you've learned?",
                "What questions do you still have about this topic?"
            ]
            
            VStack(spacing: 12) {
                ForEach(followUpQuestions, id: \.self) { question in
                    Button(action: {
                        // Start new question
                    }) {
                        HStack {
                            Text(question)
                                .font(ThinkFirstTheme.Typography.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .font(.system(size: 14))
                                .foregroundColor(ThinkFirstTheme.Colors.cyan)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .scaleEffect(1.0)
                    .animation(.easeOut(duration: 0.08), value: UUID())
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            // Ask Another Question
            Button(action: onHome) {
                Text("Ask Another Question")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            
            // Share Button
            Button(action: {
                // Implement sharing
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16))
                    
                    Text("Share This Learning")
                        .font(.system(size: 15, weight: .medium))
                }
                .foregroundColor(ThinkFirstTheme.Colors.cyan)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ThinkFirstTheme.Colors.cyan.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ThinkFirstTheme.Colors.cyan.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
}

#Preview {
    AnswerScreen(
        question: "How does photosynthesis work?",
        evaluation: Evaluation(
            effortScore: 3,
            understandingScore: 2,
            copied: false,
            whatIsRight: "You correctly identified the key components.",
            whatIsMissing: "You could explain the chemical equation.",
            unlock: true,
            fullExplanation: "Photosynthesis is the process by which plants convert light energy into chemical energy. It occurs in the chloroplasts and involves two main stages: the light-dependent reactions and the Calvin cycle.",
            coachHint: nil,
            levelUpTip: "Try to think about the inputs and outputs of biological processes."
        ),
        onHome: {}
    )
}