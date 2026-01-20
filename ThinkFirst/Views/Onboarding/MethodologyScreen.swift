//
//  MethodologyScreen.swift
//  ThinkFirst
//
//  Explains how ThinkFirst works differently from other AI tools
//

import SwiftUI

struct MethodologyScreen: View {
    let onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
                
                // Ambient gradients
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 150)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.25)
                
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 150)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.75)
                
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer(minLength: 60)
                        
                        // Header
                        headerView
                        
                        // Comparison Diagram
                        comparisonView
                        
                        // Main Message
                        mainMessageView
                        
                        // Continue Button
                        continueButtonView
                        
                        // Reassurance text
                        Text("Don't worry, we'll guide you through your first question")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 12) {
            Text("How ThinkFirst\nworks differently")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("We're not just another AI homework tool")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Comparison View
    private var comparisonView: some View {
        VStack(spacing: 24) {
            // Traditional AI (Bad)
            traditionalAICard
            
            // ThinkFirst (Good)
            thinkFirstCard
        }
    }
    
    // MARK: - Traditional AI Card
    private var traditionalAICard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Label
            HStack {
                Text("Other AIs")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1)
                            )
                    )
                
                Spacer()
            }
            
            // Diagram
            HStack(spacing: 16) {
                // Robot Icon
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                            )
                        
                        Image(systemName: "robot")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                    
                    Text("AI")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                // Arrow
                Image(systemName: "arrow.right")
                    .font(.system(size: 24))
                    .foregroundColor(.gray.opacity(0.6))
                
                // User Icon
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                            )
                        
                        Image(systemName: "person")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                    
                    Text("You")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Red X
                Circle()
                    .fill(Color.red.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.red)
                    )
            }
            
            // Description
            Text("AI does the thinking. You copy the answer. **No learning happens.**")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(nil)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                )
                .overlay(
                    // Red glow
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            RadialGradient(
                                colors: [Color.red.opacity(0.2), Color.clear],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .opacity(0.3)
                )
        )
    }
    
    // MARK: - ThinkFirst Card
    private var thinkFirstCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Label
            HStack {
                Text("ThinkFirst")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.green.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
                
                Spacer()
            }
            
            // Diagram
            HStack(spacing: 16) {
                // Brain Icon (Glowing)
                VStack(spacing: 4) {
                    ZStack {
                        // Glow effect
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                RadialGradient(
                                    colors: [Color.green.opacity(0.6), Color.clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 35
                                )
                            )
                            .frame(width: 70, height: 70)
                            .blur(radius: 16)
                            .scaleEffect(1.0)
                            .opacity(0.4)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.3), Color.green.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.green.opacity(0.5), lineWidth: 2)
                            )
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    Text("You")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.green)
                }
                
                // Arrow
                Image(systemName: "arrow.right")
                    .font(.system(size: 24))
                    .foregroundColor(.green.opacity(0.8))
                
                // AI Icon
                VStack(spacing: 4) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 2)
                            )
                        
                        Image(systemName: "robot")
                            .font(.system(size: 28))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    Text("AI")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Green Check
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.green)
                    )
            }
            
            // Description
            Text("**You think first.** AI evaluates your effort. Then you unlock the answer.")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(nil)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.08, opacity: 0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.green.opacity(0.4), lineWidth: 2)
                )
                .overlay(
                    // Green glow
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            RadialGradient(
                                colors: [Color.green.opacity(0.2), Color.clear],
                                center: .bottomTrailing,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .opacity(0.3)
                )
        )
    }
    
    // MARK: - Main Message
    private var mainMessageView: some View {
        VStack(spacing: 12) {
            Text("You must attempt an explanation to unlock the answer.")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Text("No shortcuts. No copy-paste. Real learning.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Continue Button
    private var continueButtonView: some View {
        Button(action: onContinue) {
            HStack(spacing: 8) {
                Text("I understand, let's try it")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [ThinkFirstTheme.Colors.electricViolet, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: ThinkFirstTheme.Colors.electricViolet.opacity(0.4), radius: 16, x: 0, y: 8)
            )
        }
        .scaleEffect(1.0)
        .animation(.easeOut(duration: 0.08), value: UUID())
    }
}

#Preview {
    MethodologyScreen(onContinue: {})
}