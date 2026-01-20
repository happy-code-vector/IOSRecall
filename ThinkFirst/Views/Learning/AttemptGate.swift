//
//  AttemptGate.swift
//  ThinkFirst
//
//  Question attempt screen matching web version
//

import SwiftUI

struct AttemptGate: View {
    let question: Question
    let onSubmit: (String, Bool) -> Void
    let onBack: () -> Void
    let previousAttempt: String?
    let coachHint: String?
    let onRevealAnswer: (() -> Void)?
    
    @EnvironmentObject var appState: AppState
    @State private var attempt = ""
    @State private var showHint = false
    @State private var copiedDetected = false
    @State private var masteryMode = false
    @State private var showCoachTip = false
    @State private var showMercyModal = false
    @State private var isShaking = false
    @State private var hintTimer: Timer?
    
    private let minimumWordCount = 8
    
    private var wordCount: Int {
        attempt.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
    
    private var canSubmit: Bool {
        wordCount >= minimumWordCount
    }
    
    private var isRevisionMode: Bool {
        previousAttempt != nil && coachHint != nil
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 32) {
                            // Question Display
                            questionDisplayView
                            
                            // Text Area
                            textAreaView
                            
                            // Info Text
                            infoTextView
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120) // Space for submit button
                    }
                }
                
                // Coach Tip Banner
                if isRevisionMode && showCoachTip && coachHint != nil {
                    coachTipBanner
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Submit Button
                submitButtonView
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
            }
        }
        .onAppear {
            setupInitialState()
        }
        .onDisappear {
            hintTimer?.invalidate()
        }
        .sheet(isPresented: $showMercyModal) {
            MercyModal(
                onRevealAnswer: {
                    showMercyModal = false
                    onRevealAnswer?()
                },
                coachTip: "Hint: Try defining the key term first!"
            )
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button(action: onBack) {
                Text("← Back")
                    .font(ThinkFirstTheme.Typography.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Question Display
    private var questionDisplayView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Lock icon badge
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            masteryMode ?
                            LinearGradient(
                                colors: [Color.orange.opacity(0.2), Color.orange.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [ThinkFirstTheme.Colors.electricViolet.opacity(0.2), Color.purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(
                                    masteryMode ? Color.orange.opacity(0.3) : ThinkFirstTheme.Colors.electricViolet.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                    
                    Image(systemName: "lock")
                        .font(.system(size: 20))
                        .foregroundColor(masteryMode ? Color.orange : ThinkFirstTheme.Colors.electricViolet)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(masteryMode ? "MASTERY CHALLENGE" : "THINK FIRST")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .tracking(1.2)
                }
            }
            
            // Question
            Text(question.text)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(nil)
            
            // Mastery Mode Toggle
            masteryModeToggle
        }
    }
    
    // MARK: - Mastery Mode Toggle
    private var masteryModeToggle: some View {
        VStack(spacing: 12) {
            Button(action: toggleMasteryMode) {
                HStack(spacing: 12) {
                    // Toggle Switch
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                masteryMode ?
                                LinearGradient(
                                    colors: [Color.orange, Color.orange.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                Color.white.opacity(0.2)
                            )
                            .frame(width: 48, height: 24)
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                            .offset(x: masteryMode ? 12 : -12)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: masteryMode)
                        
                        if !appState.isPremium && !masteryMode {
                            Image(systemName: "lock")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .offset(x: 12)
                        }
                    }
                    
                    // Label
                    HStack(spacing: 8) {
                        Image(systemName: "bolt")
                            .font(.system(size: 16))
                            .foregroundColor(masteryMode ? Color.orange : .gray)
                        
                        Text("Mastery Mode")
                            .font(ThinkFirstTheme.Typography.subheadline)
                            .foregroundColor(masteryMode ? Color.orange : .gray)
                    }
                    
                    Spacer()
                    
                    // Badge or Lock
                    if masteryMode {
                        HStack(spacing: 4) {
                            Image(systemName: "award")
                                .font(.system(size: 12))
                            Text("+2X XP")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(0.5)
                        }
                        .foregroundColor(Color.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .transition(.scale.combined(with: .opacity))
                    } else if !appState.isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "lock")
                                .font(.system(size: 12))
                            Text("PRO")
                                .font(.system(size: 10, weight: .bold))
                                .tracking(0.5)
                        }
                        .foregroundColor(Color.purple.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(Color.purple.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            masteryMode ?
                            Color.orange.opacity(0.15) :
                            Color.white.opacity(0.05)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    masteryMode ?
                                    Color.orange.opacity(0.3) :
                                    Color.white.opacity(0.1),
                                    lineWidth: 1
                                )
                        )
                )
            }
            .scaleEffect(1.0)
            .animation(.easeOut(duration: 0.08), value: masteryMode)
            
            // Mastery Mode Description
            if masteryMode {
                HStack(spacing: 8) {
                    Text("🔥")
                        .font(.system(size: 16))
                    
                    Text("AI expects deeper analysis. Worth 2x experience points.")
                        .font(.system(size: 13))
                        .foregroundColor(Color.orange)
                        .lineLimit(nil)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                        )
                )
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: masteryMode)
    }
    
    // MARK: - Text Area
    private var textAreaView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                // Text Editor Background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.04, green: 0.04, blue: 0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                masteryMode ?
                                Color.orange.opacity(0.3) :
                                Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                    .frame(height: 300)
                
                // Text Editor
                VStack(alignment: .leading, spacing: 0) {
                    TextEditor(text: $attempt)
                        .font(.system(size: 17, design: .monospaced))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .padding(20)
                        .frame(height: 260)
                        .onChange(of: attempt) { _, newValue in
                            handleAttemptChange(newValue)
                        }
                    
                    // Word count
                    HStack {
                        Text("\(wordCount) \(wordCount == 1 ? "word" : "words")")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.4))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                }
                
                // Placeholder
                if attempt.isEmpty {
                    Text(isRevisionMode ? "Add a bit more detail..." : "Type your explanation here…")
                        .font(.system(size: 17, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 28)
                        .padding(.leading, 24)
                        .allowsHitTesting(false)
                }
                
                // Floating hint bubble
                if showHint && attempt.isEmpty {
                    floatingHintBubble
                        .offset(x: 32, y: 80)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                // Copy/Paste Warning
                if copiedDetected {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text("⚠️ Think for yourself - don't paste!")
                                .font(.system(size: 13))
                                .foregroundColor(.red)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.red.opacity(0.4), lineWidth: 1)
                                        )
                                )
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.top, -56)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
    
    // MARK: - Floating Hint Bubble
    private var floatingHintBubble: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(masteryMode ? "Show me everything you know..." : "Just give me the gist...")
                    .font(.system(size: 14))
                    .foregroundColor(masteryMode ? Color.orange : ThinkFirstTheme.Colors.cyan)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                masteryMode ?
                                Color.orange.opacity(0.2) :
                                ThinkFirstTheme.Colors.cyan.opacity(0.2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        masteryMode ?
                                        Color.orange.opacity(0.4) :
                                        ThinkFirstTheme.Colors.cyan.opacity(0.4),
                                        lineWidth: 1
                                    )
                            )
                    )
                
                Spacer()
            }
            
            // Pointer
            HStack {
                Rectangle()
                    .fill(
                        masteryMode ?
                        Color.orange.opacity(0.2) :
                        ThinkFirstTheme.Colors.cyan.opacity(0.2)
                    )
                    .frame(width: 8, height: 8)
                    .rotationEffect(.degrees(45))
                    .offset(x: 24, y: -4)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Info Text
    private var infoTextView: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 16))
                .foregroundColor(ThinkFirstTheme.Colors.cyan)
                .padding(.top, 2)
            
            Text("The AI will evaluate your effort. Show genuine thinking to unlock the answer.")
                .font(.system(size: 14))
                .foregroundColor(ThinkFirstTheme.Colors.cyan)
                .lineLimit(nil)
        }
    }
    
    // MARK: - Coach Tip Banner
    private var coachTipBanner: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                // Glow effect
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        RadialGradient(
                            colors: [
                                ThinkFirstTheme.Colors.electricViolet.opacity(0.5),
                                Color.purple.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .frame(height: 120)
                    .blur(radius: 20)
                    .opacity(0.4)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                
                // Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        // Header
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(ThinkFirstTheme.Colors.electricViolet.opacity(0.3))
                                    .frame(width: 32, height: 32)
                                
                                Text("🎯")
                                    .font(.system(size: 16))
                            }
                            
                            Text("Coach Tip")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                        }
                        
                        Spacer()
                        
                        // Close button
                        Button(action: {
                            showCoachTip = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 28, height: 28)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.05))
                                )
                        }
                    }
                    
                    // Hint text
                    if let hint = coachHint {
                        Text(hint)
                            .font(.system(size: 15))
                            .foregroundColor(Color.purple.opacity(0.9))
                            .lineLimit(nil)
                    }
                    
                    // Footer
                    Divider()
                        .background(ThinkFirstTheme.Colors.electricViolet.opacity(0.2))
                    
                    Text("You're on the right track - just need a bit more detail.")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.95))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ThinkFirstTheme.Colors.electricViolet.opacity(0.4), lineWidth: 2)
                        )
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 112) // Above submit button
            }
        }
    }
    
    // MARK: - Submit Button
    private var submitButtonView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: handleSubmit) {
                    Text(canSubmit ? "→ Submit Answer" : "Start typing to continue...")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    canSubmit ?
                                    (masteryMode ?
                                     LinearGradient(
                                        colors: [Color.orange, Color.orange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                     ) :
                                     LinearGradient(
                                        colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                     )) :
                                    Color.white.opacity(0.1)
                                )
                        )
                }
                .disabled(!canSubmit)
                .scaleEffect(isShaking ? 0.98 : 1.0)
                .animation(.easeOut(duration: 0.08), value: isShaking)
                
                if canSubmit {
                    Text("⌘ + Enter to submit")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.clear, ThinkFirstTheme.Colors.pureBlack, ThinkFirstTheme.Colors.pureBlack],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
    
    // MARK: - Actions
    private func setupInitialState() {
        if let previousAttempt = previousAttempt {
            attempt = previousAttempt
        }
        
        showCoachTip = isRevisionMode && coachHint != nil
        
        // Start hint timer
        startHintTimer()
    }
    
    private func startHintTimer() {
        hintTimer?.invalidate()
        hintTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            if attempt.isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showHint = true
                }
            }
        }
    }
    
    private func handleAttemptChange(_ newValue: String) {
        // Reset hint when user starts typing
        if !newValue.isEmpty && showHint {
            withAnimation(.easeInOut(duration: 0.3)) {
                showHint = false
            }
        }
        
        // Restart hint timer if text becomes empty
        if newValue.isEmpty {
            startHintTimer()
        } else {
            hintTimer?.invalidate()
        }
        
        // Simple copy/paste detection
        if newValue.count - attempt.count > 100 {
            withAnimation(.easeInOut(duration: 0.3)) {
                copiedDetected = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    copiedDetected = false
                }
            }
        }
    }
    
    private func toggleMasteryMode() {
        if !appState.isPremium && !masteryMode {
            // Show upgrade prompt
            return
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            masteryMode.toggle()
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func handleSubmit() {
        guard canSubmit else {
            // Shake animation
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                isShaking = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isShaking = false
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            
            return
        }
        
        onSubmit(attempt, masteryMode)
    }
}

#Preview {
    AttemptGate(
        question: Question(text: "How does photosynthesis work?"),
        onSubmit: { _, _ in },
        onBack: {},
        previousAttempt: nil,
        coachHint: nil,
        onRevealAnswer: nil
    )
    .environmentObject(AppState())
}