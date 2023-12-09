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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [
                    ReceptItem.self,
                    IngredientItem.self,
                    User.self
                ])
        }
    }
}
