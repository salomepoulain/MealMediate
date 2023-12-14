//
//  projectApp.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

@main
struct projectApp: App {
    
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ReceptenContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}
