//
//  RootView.swift
//  ThinkFirst
//
//  Root navigation controller
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingFlow()
            } else if appState.currentUser == nil {
                LoginScreen()
            } else if appState.isStudent {
                StudentMainView()
            } else {
                ParentMainView()
            }
        }
        .background(ThinkFirstTheme.Colors.pureBlack.ignoresSafeArea())
    }
}

// MARK: - Student Main View
struct StudentMainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tabItem {
                    Label("Learn", systemImage: "brain")
                }
                .tag(0)
            
            ProgressScreen()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(1)
            
            HistoryScreen()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(2)
            
            TechniquesScreen()
                .tabItem {
                    Label("Techniques", systemImage: "book.fill")
                }
                .tag(3)
            
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(ThinkFirstTheme.Colors.electricViolet)
    }
}

// MARK: - Parent Main View
struct ParentMainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ParentDashboard()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            FamilyLeaderboard()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy.fill")
                }
                .tag(1)
            
            ParentProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
        .accentColor(ThinkFirstTheme.Colors.gold)
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
