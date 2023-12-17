//
//  projectApp.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

// MARK: - projectApp

@main
struct projectApp: App {
    
    // AppStorage to track whether it's the first time launching the app
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            // ContentView as the main content of the app
            ContentView()
                .modelContainer(ReceptenContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}


