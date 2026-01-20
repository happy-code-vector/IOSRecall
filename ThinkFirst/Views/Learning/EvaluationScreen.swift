//
//  EvaluationScreen.swift
//  ThinkFirst
//
//  Evaluation results screen matching web version
//

import SwiftUI

struct EvaluationScreen: View {
    let question: Question
    let attempt: String
    let evaluation: Evaluation?
    let isLoading: Bool
    let isRevisionMode: Bool
    let onUnlock: () -> Void
    let onRetry: () -> Void
    let onHome: () -> Void
    
    @State private var showUnlock = false
    @State private var effortProgress: Double = 0
    @State private var understandingProgress: Double = 0
    @State private var showShareCard = false
    
    private var effortPercent: Int {
        guard let evaluation = evaluation else { return 0 }
        return Int((Double(evaluation.effortScore) / 3.0) * 100)
    }
    
    private var understandingPercent: Int {
        guard let evaluation = evaluation else { return 0 }
        return Int((Double(evaluation.understandingScore) / 3.0) * 100)
    }
    
    private var isHighEffort: Bool {
        guard let evaluation = evaluation else { return false }
        return Double(evaluation.effortScore) >= 2.5
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
                
                // Ambient purple glow
                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 600, height: 600)
                    .blur(radius: 150)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 4)
                
                if isLoading || evaluation == nil {
                    // Loading State
                    loadingStateView
                } else {
                    // Results State
                    resultsStateView
                }
                
                // Back button during loading
                if isLoading {
                    VStack {
                        Spacer()
                        
                        Button(action: onHome) {
                            Text("← Back to Home")
                                .font(ThinkFirstTheme.Typography.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 34)
                        .background(
                            LinearGradient(
                                colors: [Color.clear, ThinkFirstTheme.Colors.pureBlack, ThinkFirstTheme.Colors.pureBlack],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
            }
        }
        .onAppear {
            setupAnimations()
        }
        .sheet(isPresented: $showShareCard) {
            ShareCard(
                question: question.text,
                effortScore: evaluation?.effortScore ?? 0,
                understandingScore: evaluation?.understandingScore ?? 0
            )
        }
    }
    
    // MARK: - Loading State
    private var loadingStateView: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Loading Animation
            EvaluationLoadingState()
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Results State
    private var resultsStateView: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header with question
                headerView
                    .padding(.top, 56)
                
                // Score Rings
                scoreRingsView
                
                // Feedback Cards
                if let evaluation = evaluation {
                    feedbackCardsView(evaluation: evaluation)
                }
                
                // Unlock Button or Retry
                actionButtonsView
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Your Evaluation")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(question.text)
                .font(ThinkFirstTheme.Typography.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
    }
    
    // MARK: - Score Rings
    private var scoreRingsView: some View {
        HStack(spacing: 40) {
            // Effort Score Ring
            VStack(spacing: 12) {
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    // Progress ring
                    Circle()
                        .trim(from: 0, to: effortProgress / 100)
                        .stroke(
                            LinearGradient(
                                colors: [ThinkFirstTheme.Colors.cyan, Color.blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0).delay(0.6), value: effortProgress)
                    
                    // Score text
                    VStack(spacing: 2) {
                        Text("\(effortPercent)%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(evaluation?.effortScore ?? 0)/3")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Text("Effort")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ThinkFirstTheme.Colors.cyan)
            }
            
            // Understanding Score Ring
            VStack(spacing: 12) {
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    // Progress ring
                    Circle()
                        .trim(from: 0, to: understandingProgress / 100)
                        .stroke(
                            LinearGradient(
                                colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0).delay(0.8), value: understandingProgress)
                    
                    // Score text
                    VStack(spacing: 2) {
                        Text("\(understandingPercent)%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("\(evaluation?.understandingScore ?? 0)/3")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Text("Understanding")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
            }
        }
    }
    
    // MARK: - Feedback Cards
    private func feedbackCardsView(evaluation: Evaluation) -> some View {
        VStack(spacing: 16) {
            // What's Right Card
            if !evaluation.whatIsRight.isEmpty {
                FeedbackCard(
                    title: "What's Right",
                    content: evaluation.whatIsRight,
                    icon: "checkmark.circle",
                    color: ThinkFirstTheme.Colors.success
                )
            }
            
            // What's Missing Card
            if !evaluation.whatIsMissing.isEmpty {
                FeedbackCard(
                    title: "What's Missing",
                    content: evaluation.whatIsMissing,
                    icon: "lightbulb",
                    color: ThinkFirstTheme.Colors.warning
                )
            }
            
            // Coach Hint Card (for revision mode)
            if let coachHint = evaluation.coachHint, !coachHint.isEmpty {
                FeedbackCard(
                    title: "Coach Hint",
                    content: coachHint,
                    icon: "target",
                    color: ThinkFirstTheme.Colors.electricViolet
                )
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            if let evaluation = evaluation {
                if evaluation.unlock {
                    // Unlock Button
                    Button(action: {
                        // Haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedback.impactOccurred()
                        
                        onUnlock()
                    }) {
                        HStack(spacing: 12) {
                            if showUnlock {
                                Image(systemName: "lock.open")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            Text("🎉 Unlock Answer")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ThinkFirstTheme.Colors.success, Color.green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: ThinkFirstTheme.Colors.success.opacity(0.3), radius: 20, x: 0, y: 8)
                        )
                    }
                    .scaleEffect(showUnlock ? 1.0 : 0.95)
                    .opacity(showUnlock ? 1.0 : 0.8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showUnlock)
                } else {
                    // Retry Button
                    Button(action: onRetry) {
                        Text("Try Again")
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
                }
                
                // Share Button (for high effort scores)
                if isHighEffort && !evaluation.copied {
                    Button(action: {
                        showShareCard = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16))
                            
                            Text("Share Achievement")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ThinkFirstTheme.Colors.electricViolet.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(ThinkFirstTheme.Colors.electricViolet.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            
            // Home Button
            Button(action: onHome) {
                Text("← Back to Home")
                    .font(ThinkFirstTheme.Typography.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
    }
    
    // MARK: - Setup Animations
    private func setupAnimations() {
        guard let evaluation = evaluation else { return }
        
        // Show unlock animation
        if evaluation.unlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showUnlock = true
                }
            }
        }
        
        // Animate progress rings
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            effortProgress = Double(effortPercent)
            understandingProgress = Double(understandingPercent)
        }
        
        // Auto-show share card for high effort scores
        if isHighEffort && !evaluation.copied {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                showShareCard = true
            }
        }
    }
}

// MARK: - Feedback Card
struct FeedbackCard: View {
    let title: String
    let content: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }
            
            Text(content)
                .font(ThinkFirstTheme.Typography.body)
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Evaluation Loading State
struct EvaluationLoadingState: View {
    @State private var currentMessageIndex = 0
    @State private var animationTimer: Timer?
    
    private let loadingMessages = [
        "Analyzing your thinking...",
        "Checking for understanding...",
        "Evaluating effort level...",
        "Preparing feedback...",
        "Almost ready..."
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            // Animated thinking icon
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                // Animated ring
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: UUID())
                
                // Brain icon
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32))
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
            }
            
            // Loading message
            VStack(spacing: 8) {
                Text(loadingMessages[currentMessageIndex])
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                
                // Dots animation
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(ThinkFirstTheme.Colors.electricViolet)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.0)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: UUID()
                            )
                    }
                }
            }
        }
        .onAppear {
            startMessageCycling()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }
    
    private func startMessageCycling() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentMessageIndex = (currentMessageIndex + 1) % loadingMessages.count
            }
        }
    }
}

// MARK: - Share Card
struct ShareCard: View {
    let question: String
    let effortScore: Int
    let understandingScore: Int
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Achievement Badge
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                    
                    Text("Great Thinking!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("You showed excellent effort on this question")
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                // Question and Scores
                VStack(alignment: .leading, spacing: 16) {
                    Text("Question:")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(question)
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                        )
                    
                    HStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text("Effort")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(effortScore)/3")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(ThinkFirstTheme.Colors.cyan)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Understanding")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("\(understandingScore)/3")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Share Button
                Button(action: {
                    // Implement sharing functionality
                    dismiss()
                }) {
                    Text("Share Achievement")
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
            }
            .padding(24)
            .background(ThinkFirstTheme.Colors.pureBlack)
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                }
            }
        }
    }
}

#Preview {
    EvaluationScreen(
        question: Question(text: "How does photosynthesis work?"),
        attempt: "Plants use sunlight to make food through photosynthesis...",
        evaluation: Evaluation(
            effortScore: 3,
            understandingScore: 2,
            copied: false,
            whatIsRight: "You correctly identified that plants use sunlight to make food.",
            whatIsMissing: "You could explain the role of chlorophyll and the chemical equation.",
            unlock: true,
            fullExplanation: nil,
            coachHint: nil,
            levelUpTip: nil
        ),
        isLoading: false,
        isRevisionMode: false,
        onUnlock: {},
        onRetry: {},
        onHome: {}
    )
}