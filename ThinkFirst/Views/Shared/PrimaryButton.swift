//
//  PrimaryButton.swift
//  ThinkFirst
//
//  Primary button with tap animation
//

import SwiftUI

enum ButtonStyle {
    case primary
    case secondary
    case gold
    case danger
    
    var backgroundColor: Color {
        switch self {
        case .primary: return ThinkFirstTheme.Colors.electricViolet
        case .secondary: return ThinkFirstTheme.Colors.surfaceGlass
        case .gold: return ThinkFirstTheme.Colors.gold
        case .danger: return ThinkFirstTheme.Colors.error
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .gold, .danger: return .white
        case .secondary: return ThinkFirstTheme.Colors.ghostWhite
        }
    }
}

struct PrimaryButton: View {
    let title: String
    let style: ButtonStyle
    let isDisabled: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        _ title: String,
        style: ButtonStyle = .primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                action()
            }
        }) {
            Text(title)
                .font(ThinkFirstTheme.Typography.headline)
                .foregroundColor(isDisabled ? style.textColor.opacity(0.5) : style.textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                        .fill(isDisabled ? style.backgroundColor.opacity(0.3) : style.backgroundColor)
                )
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.08), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isDisabled {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .disabled(isDisabled)
    }
}

#Preview {
    ZStack {
        ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
        
        VStack(spacing: 16) {
            PrimaryButton("Primary Button", style: .primary) {
                print("Tapped")
            }
            
            PrimaryButton("Secondary Button", style: .secondary) {
                print("Tapped")
            }
            
            PrimaryButton("Gold Button", style: .gold) {
                print("Tapped")
            }
            
            PrimaryButton("Disabled Button", isDisabled: true) {
                print("Tapped")
            }
        }
        .padding()
    }
}
