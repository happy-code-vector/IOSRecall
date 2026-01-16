//
//  Badge.swift
//  ThinkFirst
//
//  Badge system models
//

import Foundation

enum BadgeCategory: String, Codable {
    case streaks
    case mastery
    case milestones
}

struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let category: BadgeCategory
    let iconName: String
    let requirement: String
    var unlockedAt: Date?
    
    var isUnlocked: Bool {
        unlockedAt != nil
    }
}

// Badge definitions matching PRD
extension Badge {
    static let allBadges: [Badge] = [
        // Streaks
        Badge(id: "ignition", name: "Ignition", description: "3 day streak", category: .streaks, iconName: "flame", requirement: "3_day_streak"),
        Badge(id: "furnace", name: "The Furnace", description: "7 day streak", category: .streaks, iconName: "flame.fill", requirement: "7_day_streak"),
        Badge(id: "momentum", name: "Momentum", description: "14 day streak", category: .streaks, iconName: "bolt.fill", requirement: "14_day_streak"),
        Badge(id: "blue_giant", name: "Blue Giant", description: "30 day streak", category: .streaks, iconName: "star.fill", requirement: "30_day_streak"),
        Badge(id: "century", name: "The Century", description: "100 day streak", category: .streaks, iconName: "crown.fill", requirement: "100_day_streak"),
        Badge(id: "reboot", name: "The Reboot", description: "Used a Streak Freeze", category: .streaks, iconName: "arrow.clockwise", requirement: "used_freeze"),
        
        // Mastery
        Badge(id: "synapse", name: "Synapse", description: "First high effort score", category: .mastery, iconName: "brain", requirement: "first_high_effort"),
        Badge(id: "deep_dive", name: "Deep Dive", description: "Perfect score", category: .mastery, iconName: "scope", requirement: "perfect_score"),
        Badge(id: "vanguard", name: "Vanguard", description: "Unlocked in Mastery Mode", category: .mastery, iconName: "shield.fill", requirement: "mastery_unlock"),
        Badge(id: "architect", name: "The Architect", description: "Perfect structure", category: .mastery, iconName: "cube.fill", requirement: "perfect_structure"),
        Badge(id: "polymath", name: "The Polymath", description: "5 different subjects", category: .mastery, iconName: "sparkles", requirement: "5_subjects"),
        Badge(id: "night_shift", name: "Night Shift", description: "High effort after 11 PM", category: .mastery, iconName: "moon.stars.fill", requirement: "night_effort"),
        Badge(id: "refiner", name: "The Refiner", description: "Edited attempt 3+ times", category: .mastery, iconName: "pencil.circle.fill", requirement: "3_edits"),
        
        // Milestones
        Badge(id: "initiate", name: "The Initiate", description: "First unlock", category: .milestones, iconName: "key.fill", requirement: "first_unlock"),
        Badge(id: "apprentice", name: "The Apprentice", description: "10 unlocks", category: .milestones, iconName: "star.circle.fill", requirement: "10_unlocks"),
        Badge(id: "operator", name: "The Operator", description: "50 unlocks", category: .milestones, iconName: "gearshape.fill", requirement: "50_unlocks"),
        Badge(id: "veteran", name: "The Veteran", description: "100 unlocks", category: .milestones, iconName: "medal.fill", requirement: "100_unlocks"),
        Badge(id: "apex", name: "The Apex", description: "500 unlocks", category: .milestones, iconName: "diamond.fill", requirement: "500_unlocks"),
        Badge(id: "archivist", name: "The Archivist", description: "Saved 20 items", category: .milestones, iconName: "archivebox.fill", requirement: "20_saved"),
        Badge(id: "early_riser", name: "Early Riser", description: "Unlock before 8 AM", category: .milestones, iconName: "sunrise.fill", requirement: "early_unlock")
    ]
}
