//
//  Family.swift
//  ThinkFirst
//
//  Family and parent dashboard models
//

import Foundation

struct FamilyInvite: Codable {
    let code: String
    let parentUserId: String
    let expiresAt: Date
    var usedBy: [String]
    
    var isExpired: Bool {
        Date() > expiresAt
    }
    
    var isValid: Bool {
        !isExpired && usedBy.count < 5
    }
}

struct FamilyMember: Codable, Identifiable {
    let id: String
    let name: String
    let avatarURL: String?
    let currentStreak: Int
    let questionsThisWeek: Int
    let averageScore: Double
    let xp: Int
    let badges: [String]
}

struct LeaderboardEntry: Identifiable {
    let id: String
    let rank: Int
    let member: FamilyMember
    let score: Int
    let isCurrentUser: Bool
}

enum LeaderboardTimeframe: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case allTime = "All-Time"
}

struct FamilySquadStreak: Codable {
    var count: Int
    var lastActiveDate: Date?
    var participatingMembers: [String]
    
    static var empty: FamilySquadStreak {
        FamilySquadStreak(count: 0, lastActiveDate: nil, participatingMembers: [])
    }
}

struct GuardianSettings: Codable {
    var forceMasteryMode: Bool
    var blockMercyButton: Bool
    var enableWeeklyReports: Bool
    var reportEmail: String?
    var contentFilters: [String]
    var dailyTimeLimit: Int? // minutes
    
    static var `default`: GuardianSettings {
        GuardianSettings(
            forceMasteryMode: false,
            blockMercyButton: false,
            enableWeeklyReports: true,
            reportEmail: nil,
            contentFilters: [],
            dailyTimeLimit: nil
        )
    }
}
