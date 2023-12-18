//
//  ReceptenContainer.swift
//  project
//
//  Created by Salome Poulain on 14/12/2023.
//

import Foundation
import SwiftData

// MARK: - ReceptenContainer

// An actor responsible for creating and configuring the ModelContainer for the app.
actor ReceptenContainer {

    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        
        // Define the schema for the data model
        let schema = Schema([
            ReceptItem.self,
            IngredientItem.self,
            User.self
        ])
        
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        if shouldCreateDefaults {
            
            // Decode standard ingredients from a JSON file
            let ingredienten = IngredientenJSONDecoder.decode(from: "StandaardIngredienten")
            
            // Insert decoded ingredients into the main context
            if !ingredienten.isEmpty {
                ingredienten.forEach { item in
                    let ingredient = IngredientItem(naam: item.naam)
                    container.mainContext.insert(ingredient)
                }
            }
            
            // Create a new user and insert it into the main context
            let newUser = User(id: 1, startDay: 0)
            container.mainContext.insert(newUser)
            
            shouldCreateDefaults = false
        }
        return container
    }
}
