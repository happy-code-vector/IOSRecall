//
//  MercyModal.swift
//  ThinkFirst
//
//  Modal for revealing answer with consequences
//

import SwiftUI

struct MercyModal: View {
    let onRevealAnswer: () -> Void
    let coachTip: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var showWarning = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // Warning Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundColor(.red)
                }
                .scaleEffect(showWarning ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: showWarning)
                
                // Title and Description
                VStack(spacing: 16) {
                    Text("Give Up?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("You can reveal the answer, but you'll miss out on the learning experience and won't earn full points.")
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                
                // Coach Tip
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "lightbulb")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                        
                        Text("Coach Tip")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.yellow)
                    }
                    
                    Text(coachTip)
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(nil)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.yellow.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                        )
                )
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Keep Trying Button (Primary)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Keep Trying")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
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
                            )
                    }
                    
                    // Reveal Answer Button (Secondary)
                    Button(action: {
                        dismiss()
                        onRevealAnswer()
                    }) {
                        Text("Reveal Answer")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.red.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(24)
            .background(ThinkFirstTheme.Colors.pureBlack)
            .navigationTitle("Mercy Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                }
            }
        }
        .onAppear {
            showWarning = true
        }
    }
}

#Preview {
    MercyModal(
        onRevealAnswer: {},
        coachTip: "Hint: Try defining the key term first!"
    )
}