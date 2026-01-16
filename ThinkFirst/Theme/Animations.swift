//
//  Animations.swift
//  ThinkFirst
//
//  Animation helpers and presets matching PRD specifications
//

import SwiftUI

// MARK: - Animation Presets
extension Animation {
    /// Fast animation (150-180ms) - For taps, ripple feedback
    static let thinkFirstFast = Animation.easeInOut(duration: 0.15)
    
    /// Standard animation (220-260ms) - For screen transitions, cards
    static let thinkFirstStandard = Animation.easeInOut(duration: 0.22)
    
    /// Slow animation (300-350ms) - For unlock animation, streak progress
    static let thinkFirstSlow = Animation.easeInOut(duration: 0.3)
    
    /// Unlock animation - Signature moment
    static let thinkFirstUnlock = Animation.easeInOut(duration: 0.3)
}

// MARK: - Transition Presets
extension AnyTransition {
    /// Screen push transition (forward navigation)
    /// Slides in from right 16-24px + fade in, 220ms
    static var screenPush: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
    
    /// Screen pop transition (back navigation)
    /// Slides right 16-24px + fade out, 200ms
    static var screenPop: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }
    
    /// Slide up transition for modals and cards
    /// Slides up 16px + fade in, 260ms
    static var slideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }
}

// MARK: - Button Tap Animation
struct ButtonTapModifier: ViewModifier {
    @Binding var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.08), value: isPressed)
    }
}

extension View {
    func buttonTapAnimation(isPressed: Binding<Bool>) -> some View {
        modifier(ButtonTapModifier(isPressed: isPressed))
    }
}

// MARK: - Streak Animation
struct StreakAnimationModifier: ViewModifier {
    let trigger: Bool
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onChange(of: trigger) { _, _ in
                // Scale animation: 100% → 110% → 100%
                withAnimation(.easeInOut(duration: 0.175)) {
                    scale = 1.1
                    opacity = 0.7
                }
                
                withAnimation(.easeInOut(duration: 0.175).delay(0.175)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

extension View {
    func streakAnimation(trigger: Bool) -> some View {
        modifier(StreakAnimationModifier(trigger: trigger))
    }
}

// MARK: - Unlock Animation
struct UnlockAnimationModifier: ViewModifier {
    let isUnlocked: Bool
    @State private var rotation: Double = 0
    @State private var shackleOffset: CGFloat = 0
    @State private var glowOpacity: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .offset(y: shackleOffset)
            .background(
                Circle()
                    .fill(ThinkFirstTheme.Colors.electricViolet.opacity(glowOpacity))
                    .blur(radius: 20)
                    .scaleEffect(1.5)
            )
            .onChange(of: isUnlocked) { _, unlocked in
                if unlocked {
                    performUnlockAnimation()
                }
            }
    }
    
    private func performUnlockAnimation() {
        // Rotation: 0° → -12° → 0° (subtle)
        withAnimation(.easeInOut(duration: 0.15)) {
            rotation = -12
        }
        withAnimation(.easeInOut(duration: 0.15).delay(0.15)) {
            rotation = 0
        }
        
        // Shackle moves up 4px
        withAnimation(.easeInOut(duration: 0.3)) {
            shackleOffset = -4
        }
        
        // Glow: 0 → 50% → 0
        withAnimation(.easeInOut(duration: 0.125)) {
            glowOpacity = 0.5
        }
        withAnimation(.easeInOut(duration: 0.125).delay(0.125)) {
            glowOpacity = 0
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
}

extension View {
    func unlockAnimation(isUnlocked: Bool) -> some View {
        modifier(UnlockAnimationModifier(isUnlocked: isUnlocked))
    }
}

// MARK: - Badge Unlock Animation
struct BadgeUnlockAnimationModifier: ViewModifier {
    let isUnlocked: Bool
    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .rotationEffect(.degrees(rotation))
            .onChange(of: isUnlocked) { _, unlocked in
                if unlocked {
                    performBadgeUnlockAnimation()
                }
            }
    }
    
    private func performBadgeUnlockAnimation() {
        // Scale: 0% → 110% → 100%
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            scale = 1.1
        }
        withAnimation(.spring(response: 0.2, dampingFraction: 0.8).delay(0.4)) {
            scale = 1.0
        }
        
        // Subtle rotation for flair
        withAnimation(.easeInOut(duration: 0.6)) {
            rotation = 360
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
}

extension View {
    func badgeUnlockAnimation(isUnlocked: Bool) -> some View {
        modifier(BadgeUnlockAnimationModifier(isUnlocked: isUnlocked))
    }
}

// MARK: - Loading State Animation
struct LoadingTextCycler: View {
    let texts: [String]
    @State private var currentIndex = 0
    
    init(texts: [String] = [
        "Reading your attempt...",
        "Analyzing logic...",
        "Checking accuracy...",
        "Unlocking..."
    ]) {
        self.texts = texts
    }
    
    var body: some View {
        Text(texts[currentIndex])
            .font(ThinkFirstTheme.Typography.body)
            .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
            .transition(.opacity)
            .id(currentIndex)
            .onAppear {
                startCycling()
            }
    }
    
    private func startCycling() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentIndex = (currentIndex + 1) % texts.count
            }
        }
    }
}

// MARK: - Pulse Animation
struct PulseModifier: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

extension View {
    func pulse() -> some View {
        modifier(PulseModifier())
    }
}

// MARK: - Shimmer Effect (for loading states)
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        ThinkFirstTheme.Colors.ghostWhite.opacity(0.3),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 300
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Confetti Effect (for badge unlocks)
struct ConfettiView: View {
    let colors: [Color] = [
        ThinkFirstTheme.Colors.electricViolet,
        ThinkFirstTheme.Colors.cyan,
        ThinkFirstTheme.Colors.cyberMint,
        ThinkFirstTheme.Colors.gold,
        ThinkFirstTheme.Colors.safetyOrange
    ]
    
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
    }
    
    private func generateParticles(in size: CGSize) {
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                color: colors.randomElement()!,
                size: CGFloat.random(in: 4...12),
                position: CGPoint(
                    x: size.width / 2,
                    y: size.height / 2
                ),
                velocity: CGPoint(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat.random(in: -300...(-100))
                )
            )
            particles.append(particle)
            animateParticle(particle, in: size)
        }
    }
    
    private func animateParticle(_ particle: ConfettiParticle, in size: CGSize) {
        withAnimation(.easeOut(duration: 1.5)) {
            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                particles[index].position.x += particle.velocity.x
                particles[index].position.y += particle.velocity.y + 500 // gravity
                particles[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            particles.removeAll { $0.id == particle.id }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    var position: CGPoint
    let velocity: CGPoint
    var opacity: Double = 1.0
}
