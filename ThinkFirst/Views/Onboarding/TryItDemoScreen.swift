//
//  TryItDemoScreen.swift
//  ThinkFirst
//
//  Interactive demo of the ThinkFirst learning process
//

import SwiftUI

struct TryItDemoScreen: View {
    let onContinue: () -> Void
    
    @State private var typedText = ""
    @State private var showCursor = true
    @State private var showUnlockPrompt = false
    @State private var showSuccess = false
    @State private var showBadge = false
    @State private var showMessage = false
    @State private var typingTimer: Timer?
    @State private var cursorTimer: Timer?
    
    private let fullText = "It is because of Rayleigh scattering..."
    private let question = "Explain why the sky is blue."
    
    var body: some View {
        ZStack {
            // Background
            ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
            
            // Green flash overlay
            if showSuccess {
                Color.green
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 60)
                    
                    // Header
                    headerView
                    
                    // Question Card
                    questionCard
                    
                    // Input Box with Ghost Typing
                    inputBoxView
                    
                    // Unlock Prompt
                    if showUnlockPrompt {
                        unlockButton
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    // Success Badge
                    if showBadge {
                        successBadgeView
                            .transition(.scale.combined(with: .move(edge: .bottom)))
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            startTypingAnimation()
            startCursorBlinking()
        }
        .onDisappear {
            typingTimer?.invalidate()
            cursorTimer?.invalidate()
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 20))
                .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
            
            Text("Try it yourself")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .opacity(0)
        .animation(.easeInOut(duration: 0.5).delay(0.2), value: UUID())
    }
    
    // MARK: - Question Card
    private var questionCard: some View {
        HStack(alignment: .top, spacing: 12) {
            // Question icon
            Circle()
                .fill(ThinkFirstTheme.Colors.electricViolet.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Text("?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                )
            
            // Question text
            Text(question)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .lineLimit(nil)
            
            Spacer()
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
        )
        .opacity(0)
        .offset(y: 20)
        .animation(.easeOut(duration: 0.5).delay(0.3), value: UUID())
    }
    
    // MARK: - Input Box
    private var inputBoxView: some View {
        ZStack(alignment: .topTrailing) {
            // Input area
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(typedText + (typedText.count < fullText.count && showCursor ? "|" : ""))
                        .font(.system(size: 14, family: .monospaced))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding(16)
                
                Spacer()
            }
            .frame(minHeight: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.04, green: 0.04, blue: 0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Lock icon overlay
            ZStack {
                Circle()
                    .fill(ThinkFirstTheme.Colors.electricViolet)
                    .frame(width: 48, height: 48)
                    .shadow(color: ThinkFirstTheme.Colors.electricViolet.opacity(0.4), radius: 10, x: 0, y: 0)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                
                Image(systemName: "lock")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .offset(x: 8, y: -8)
        }
        .opacity(0)
        .offset(y: 20)
        .animation(.easeOut(duration: 0.5).delay(0.5), value: UUID())
    }
    
    // MARK: - Unlock Button
    private var unlockButton: some View {
        Button(action: handleUnlock) {
            Text("Tap to Unlock")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
        }
        .scaleEffect(1.0)
        .animation(.easeOut(duration: 0.08), value: UUID())
    }
    
    // MARK: - Success Badge
    private var successBadgeView: some View {
        VStack(spacing: 24) {
            // High Effort Badge
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "sparkles")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    )
                
                Text("High Effort")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [ThinkFirstTheme.Colors.cyberMint, Color.green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: ThinkFirstTheme.Colors.cyberMint.opacity(0.4), radius: 20, x: 0, y: 8)
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
            )
            
            // Message
            if showMessage {
                VStack(spacing: 8) {
                    Text("You just earned your first Effort Score.")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("This is how you win.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
    
    // MARK: - Actions
    private func startTypingAnimation() {
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            if typedText.count < fullText.count {
                let nextIndex = fullText.index(fullText.startIndex, offsetBy: typedText.count + 1)
                typedText = String(fullText[..<nextIndex])
            } else {
                timer.invalidate()
                // Show unlock prompt after typing is complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showUnlockPrompt = true
                    }
                }
            }
        }
    }
    
    private func startCursorBlinking() {
        cursorTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            showCursor.toggle()
        }
    }
    
    private func handleUnlock() {
        // Hide unlock prompt
        withAnimation(.easeOut(duration: 0.2)) {
            showUnlockPrompt = false
        }
        
        // Show green flash
        withAnimation(.easeInOut(duration: 0.2)) {
            showSuccess = true
        }
        
        // Hide flash and show badge
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showSuccess = false
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showBadge = true
            }
        }
        
        // Show message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.5)) {
                showMessage = true
            }
        }
        
        // Complete the tutorial
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            onContinue()
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
}

#Preview {
    TryItDemoScreen(onContinue: {})
}