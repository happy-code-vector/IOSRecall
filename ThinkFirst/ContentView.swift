//
//  ContentView.swift
//  ThinkFirst
//
//  Root navigation controller
//

import SwiftUI

struct ContentView: View {
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

// MARK: - Missing Screen Implementations
struct LoginScreen: View {
    var body: some View {
        VStack {
            Text("Login Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct HomeScreen: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct ProgressScreen: View {
    var body: some View {
        VStack {
            Text("Progress Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct HistoryScreen: View {
    var body: some View {
        VStack {
            Text("History Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct TechniquesScreen: View {
    var body: some View {
        VStack {
            Text("Techniques Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct ProfileScreen: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct ParentDashboard: View {
    var body: some View {
        VStack {
            Text("Parent Dashboard")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct FamilyLeaderboard: View {
    var body: some View {
        VStack {
            Text("Family Leaderboard")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
}

struct ParentProfileScreen: View {
    var body: some View {
        VStack {
            Text("Parent Profile")
                .foregroundColor(.white)
            Text("Implementation needed")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ThinkFirstTheme.Colors.pureBlack)
    }
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
    ContentView()
        .environmentObject(AppState())
}
