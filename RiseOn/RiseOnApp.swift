//
//  RiseOnApp.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 30/01/2025.
//

import SwiftUI
import SwiftData

@main
struct FitAppApp: App {
    // Интегрируем SwiftData на уровне приложения
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([UserProfileModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Не удалось создать ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            MainApp()
        }
        .modelContainer(sharedModelContainer)
    }
}


