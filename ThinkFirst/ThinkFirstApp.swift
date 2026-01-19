//
//  ThinkFirstApp.swift
//  ThinkFirst
//
//  Created by Ahmad Rasheed on 1/16/26.
//

import SwiftUI
import Foundation

@main
struct ThinkFirstApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}
