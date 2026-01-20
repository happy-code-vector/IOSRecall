//
//  HomeScreen.swift
//  ThinkFirst
//
//  Main learning interface matching web version
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var appState: AppState
    @State private var questionInput = ""
    @State private var isNewUser = false
    @State private var showUpgradePrompt = false
    
    // Example questions by grade level
    private var exampleQuestions: [String] {
        switch appState.currentUser?.gradeLevel {
        case .elementary:
            return [
                "Why do plants need sunlight?",
                "What is counting by 2s?",
                "How do birds fly?",
                "What makes the seasons change?"
            ]
        case .middleSchool:
            return [
                "How does the water cycle work?",
                "What are fractions?",
                "Why do we have day and night?",
                "What is photosynthesis?"
            ]
        case .highSchool:
            return [
                "Explain Newton's first law",
                "How does DNA replication work?",
                "What is quadratic formula used for?",
                "Explain the French Revolution"
            ]
        case .college, .none:
            return [
                "What is photosynthesis?",
                "Explain Newton's first law",
                "How does DNA replication work?",
                "What caused the French Revolution?"
            ]
        }
    }
    
    // Starter challenges for new users
    private let starterChallenges = [
        StarterChallenge(
            id: "science",
            title: "Science",
            question: "How does photosynthesis work?",
            description: "Explore how plants convert light into energy",
            icon: "atom",
            gradient: [ThinkFirstTheme.Colors.electricViolet, Color.purple]
        ),
        StarterChallenge(
            id: "math",
            title: "Math",
            question: "What is the Pythagorean theorem?",
            description: "Discover the relationship between triangle sides",
            icon: "brain.head.profile",
            gradient: [ThinkFirstTheme.Colors.cyan, Color.blue]
        ),
        StarterChallenge(
            id: "history",
            title: "History",
            question: "What caused World War II?",
            description: "Understand the events that shaped the 20th century",
            icon: "building.columns",
            gradient: [ThinkFirstTheme.Colors.amber, ThinkFirstTheme.Colors.safetyOrange]
        ),
        StarterChallenge(
            id: "concepts",
            title: "Concepts",
            question: "What is artificial intelligence?",
            description: "Learn about machines that think and learn",
            icon: "lightbulb",
            gradient: [Color.yellow, ThinkFirstTheme.Colors.amber]
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea()
                
                // Subtle ambient glow
                Circle()
                    .fill(Color.gray.opacity(0.08))
                    .frame(width: 500, height: 500)
                    .blur(radius: 140)
                    .position(x: geometry.size.width / 2, y: 0)
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        headerView
                            .padding(.horizontal, 24)
                            .padding(.top, 56)
                            .padding(.bottom, 32)
                        
                        // Main Content
                        VStack(spacing: 32) {
                            // Main Prompt
                            VStack(spacing: 32) {
                                Text("What do you want to understand today?")
                                    .font(ThinkFirstTheme.Typography.title2)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                
                                // Input Field
                                inputField
                                
                                // Example Questions
                                exampleQuestionsView
                            }
                            
                            // Starter Challenges (for new users)
                            if isNewUser {
                                starterChallengesView
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120) // Space for bottom nav
                    }
                }
            }
        }
        .onAppear {
            checkIfNewUser()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 16) {
                    // Animated title
                    animatedTitle
                    
                    // Tagline with sparkle
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16))
                            .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                            .rotationEffect(.degrees(0))
                            .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: UUID())
                        
                        Text("Your Brain, Supercharged")
                            .font(ThinkFirstTheme.Typography.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.9), ThinkFirstTheme.Colors.electricViolet, Color.white.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    // Question counter for free users
                    if !appState.isPremium {
                        questionCounterBadge
                    }
                }
                
                Spacer()
                
                // Profile button
                Button(action: {
                    // Navigate to profile
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .overlay(
                            Image(systemName: "person.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        )
                }
            }
            
            // Upgrade banner for free users
            if !appState.isPremium {
                upgradeBanner
                    .padding(.top, 24)
            }
        }
    }
    
    // MARK: - Animated Title
    private var animatedTitle: some View {
        ZStack {
            // Glow effect
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [
                            ThinkFirstTheme.Colors.electricViolet.opacity(0.6),
                            Color.blue.opacity(0.4),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(height: 80)
                .blur(radius: 20)
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: UUID())
            
            // Main title
            Text("ThinkFirst")
                .font(.system(size: 36, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.8),
                            ThinkFirstTheme.Colors.electricViolet,
                            Color.blue,
                            ThinkFirstTheme.Colors.cyan
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    // MARK: - Question Counter Badge
    private var questionCounterBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(ThinkFirstTheme.Colors.cyan)
                .frame(width: 8, height: 8)
            
            Text("\(3 - appState.questionsToday) free questions left today")
                .font(ThinkFirstTheme.Typography.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .opacity(0)
        .scaleEffect(0.9)
        .animation(.easeOut(duration: 0.4).delay(0.3), value: UUID())
    }
    
    // MARK: - Upgrade Banner
    private var upgradeBanner: some View {
        Button(action: {
            showUpgradePrompt = true
        }) {
            HStack(spacing: 12) {
                // Crown icon with glow
                ZStack {
                    Circle()
                        .fill(ThinkFirstTheme.Colors.electricPurple.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .blur(radius: 12)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                    
                    Circle()
                        .fill(ThinkFirstTheme.Colors.electricPurple.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "crown")
                                .font(.system(size: 20))
                                .foregroundColor(Color.purple.opacity(0.8))
                        )
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    Text("Upgrade to Pro")
                        .font(ThinkFirstTheme.Typography.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Unlimited unlocks • Advanced feedback • From $4.99/mo")
                        .font(ThinkFirstTheme.Typography.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Arrow
                Text("→")
                    .font(.title2)
                    .foregroundColor(Color.purple.opacity(0.8))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ThinkFirstTheme.Colors.electricPurple.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ThinkFirstTheme.Colors.electricPurple.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(1.0)
        .animation(.easeOut(duration: 0.08), value: showUpgradePrompt)
    }
    
    // MARK: - Input Field
    private var inputField: some View {
        VStack(spacing: 0) {
            ZStack {
                // Subtle glow
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.05))
                    .blur(radius: 8)
                
                // Input container
                HStack {
                    TextField("Ask your question…", text: $questionInput)
                        .font(ThinkFirstTheme.Typography.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.gray.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                    
                    if !questionInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button(action: submitQuestion) {
                            Text("Ask")
                                .font(ThinkFirstTheme.Typography.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.gray.opacity(0.7))
                                )
                        }
                        .padding(.trailing, 8)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        }
    }
    
    // MARK: - Example Questions
    private var exampleQuestionsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Quick examples")
                    .font(ThinkFirstTheme.Typography.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(exampleQuestions, id: \.self) { question in
                    Button(action: {
                        startQuestion(question)
                    }) {
                        Text(question)
                            .font(ThinkFirstTheme.Typography.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                            )
                    }
                    .scaleEffect(1.0)
                    .animation(.easeOut(duration: 0.08), value: UUID())
                }
            }
        }
    }
    
    // MARK: - Starter Challenges
    private var starterChallengesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(ThinkFirstTheme.Colors.electricViolet)
                
                Text("Start your Streak")
                    .font(ThinkFirstTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(starterChallenges) { challenge in
                        StarterChallengeCard(challenge: challenge) {
                            startQuestion(challenge.question)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, -24)
        }
    }
    
    // MARK: - Actions
    private func submitQuestion() {
        let question = questionInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !question.isEmpty {
            startQuestion(question)
        }
    }
    
    private func startQuestion(_ question: String) {
        // Navigate to AttemptGate with question
        appState.currentQuestion = Question(text: question)
        appState.currentScreen = .attemptGate
    }
    
    private func checkIfNewUser() {
        // Check if user has any learning history
        isNewUser = appState.learningHistory.isEmpty
    }
}

// MARK: - Starter Challenge Model
struct StarterChallenge: Identifiable {
    let id: String
    let title: String
    let question: String
    let description: String
    let icon: String
    let gradient: [Color]
}

// MARK: - Starter Challenge Card
struct StarterChallengeCard: View {
    let challenge: StarterChallenge
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                // Icon with glow and NEW badge
                ZStack(alignment: .topTrailing) {
                    HStack {
                        ZStack {
                            // Icon glow
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    RadialGradient(
                                        colors: [challenge.gradient[0].opacity(0.6), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 30
                                    )
                                )
                                .frame(width: 56, height: 56)
                                .blur(radius: 12)
                                .opacity(0.3)
                                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: UUID())
                            
                            // Icon container
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: challenge.gradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: challenge.icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        Spacer()
                    }
                    
                    // NEW badge
                    Text("NEW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
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
                        .offset(x: 4, y: -4)
                }
                
                // Title
                Text(challenge.title)
                    .font(ThinkFirstTheme.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                // Description
                Text(challenge.description)
                    .font(ThinkFirstTheme.Typography.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                // Bottom indicator
                HStack {
                    Circle()
                        .fill(ThinkFirstTheme.Colors.success)
                        .frame(width: 6, height: 6)
                    
                    Text("Tap to start")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ThinkFirstTheme.Colors.success)
                    
                    Spacer()
                }
            }
            .padding(20)
            .frame(width: 256)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 20/255, green: 20/255, blue: 20/255, opacity: 0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 2)
                    )
            )
        }
        .scaleEffect(1.0)
        .animation(.easeOut(duration: 0.08), value: UUID())
    }
}

#Preview {
    HomeScreen()
        .environmentObject(AppState())
}