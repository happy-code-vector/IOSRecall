//
//  SplashScreen.swift
//  ThinkFirst
//
//  Animated splash screen
//

import SwiftUI

struct SplashScreen: View {
    let onContinue: () -> Void
    
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    ThinkFirstTheme.Colors.electricViolet,
                                    ThinkFirstTheme.Colors.cyan
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    Text("ThinkFirst")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    ThinkFirstTheme.Colors.electricViolet,
                                    ThinkFirstTheme.Colors.cyan
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(textOpacity)
                }
                
                Spacer()
                
                // Tagline
                VStack(spacing: 12) {
                    Text("AI for Thinkers")
                        .font(ThinkFirstTheme.Typography.title2)
                        .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
                        .opacity(textOpacity)
                    
                    Text("You explain first. Then we help you unlock the truth.")
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                    .frame(height: 60)
            }
        }
        .onAppear {
            // Animate logo
            withAnimation(.easeOut(duration: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Animate text
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                textOpacity = 1.0
            }
            
            // Auto-continue after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onContinue()
            }
        }
    }
}

#Preview {
    SplashScreen(onContinue: {})
}
