//
//  AccountTypeScreen.swift
//  ThinkFirst
//
//  Account type selection (Student vs Parent)
//

import SwiftUI

struct AccountTypeScreen: View {
    @Binding var selectedType: UserType?
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            // Header
            VStack(spacing: 12) {
                Text("Who are you?")
                    .font(ThinkFirstTheme.Typography.largeTitle)
                    .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
                
                Text("Choose your account type to get started")
                    .font(ThinkFirstTheme.Typography.body)
                    .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Account type cards
            VStack(spacing: 20) {
                AccountTypeCard(
                    type: .student,
                    icon: "brain",
                    title: "I am a Student",
                    description: "I want to learn and improve",
                    accentColor: ThinkFirstTheme.Colors.electricViolet,
                    isSelected: selectedType == .student
                ) {
                    selectedType = .student
                }
                
                AccountTypeCard(
                    type: .parent,
                    icon: "shield.fill",
                    title: "I am a Parent",
                    description: "I want to support my child's learning",
                    accentColor: ThinkFirstTheme.Colors.gold,
                    isSelected: selectedType == .parent
                ) {
                    selectedType = .parent
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue button
            PrimaryButton(
                "Continue",
                isDisabled: selectedType == nil
            ) {
                onContinue()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

struct AccountTypeCard: View {
    let type: UserType
    let icon: String
    let title: String
    let description: String
    let accentColor: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? accentColor : ThinkFirstTheme.Colors.textSecondary)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(isSelected ? accentColor.opacity(0.2) : ThinkFirstTheme.Colors.surfaceGlass)
                    )
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(ThinkFirstTheme.Typography.headline)
                        .foregroundColor(ThinkFirstTheme.Colors.ghostWhite)
                    
                    Text(description)
                        .font(ThinkFirstTheme.Typography.subheadline)
                        .foregroundColor(ThinkFirstTheme.Colors.textSecondary)
                }
                
                Spacer()
                
                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(accentColor)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                    .fill(ThinkFirstTheme.Colors.surfaceGlass)
                    .overlay(
                        RoundedRectangle(cornerRadius: ThinkFirstTheme.CornerRadius.medium)
                            .stroke(
                                isSelected ? accentColor : ThinkFirstTheme.Colors.glassBorder,
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AccountTypeScreen(
        selectedType: .constant(.student),
        onContinue: {}
    )
}
