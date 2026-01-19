//
//  GradeSelectionScreen.swift
//  ThinkFirst
//
//  Grade level selection for students
//

import SwiftUI

struct GradeSelectionScreen: View {
    @Binding var selectedGrade: GradeLevel?
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("What's your grade level?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("This helps us tailor questions to your level")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                ForEach(GradeLevel.allCases, id: \.self) { grade in
                    Button(action: {
                        selectedGrade = grade
                    }) {
                        HStack {
                            Text(grade.displayName)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedGrade == grade {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedGrade == grade ? 
                                      ThinkFirstTheme.Colors.electricViolet.opacity(0.2) : 
                                      Color.gray.opacity(0.1))
                                .stroke(selectedGrade == grade ? 
                                       ThinkFirstTheme.Colors.electricViolet : 
                                       Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton(
                "Continue",
                isDisabled: selectedGrade == nil,
                action: onContinue
            )
            .padding(.horizontal)
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

#Preview {
    GradeSelectionScreen(
        selectedGrade: .constant(.middleSchool),
        onContinue: {}
    )
}