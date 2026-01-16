//
//  User.swift
//  ThinkFirst
//
//  Core user models for student and parent accounts
//

import Foundation

enum UserType: String, Codable {
    case student
    case parent
}

enum GradeLevel: String, Codable, CaseIterable {
    case elementary = "Elementary"
    case middleSchool = "Middle School"
    case highSchool = "High School"
    case college = "College"
    
    var displayName: String { rawValue }
}

enum SubscriptionTier: String, Codable {
    case free
    case solo
    case family
}

struct User: Codable, Identifiable {
    let id: String
    var name: String
    var email: String?
    var type: UserType
    var gradeLevel: GradeLevel?
    var subscriptionTier: SubscriptionTier
    var avatarURL: String?
    var familyId: String?
    var createdAt: Date
    
    var isPremium: Bool {
        subscriptionTier == .solo || subscriptionTier == .family
    }
}

struct UserProgress: Codable {
    var totalQuestions: Int
    var totalUnlocks: Int
    var currentStreak: Int
    var lastActiveDate: Date?
    var xp: Int
    var level: Int
    var badges: [String]
    
    static var empty: UserProgress {
        UserProgress(
            totalQuestions: 0,
            totalUnlocks: 0,
            currentStreak: 0,
            lastActiveDate: nil,
            xp: 0,
            level: 1,
            badges: []
        )
    }
}
