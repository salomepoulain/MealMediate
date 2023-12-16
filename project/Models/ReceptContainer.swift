//
//  ReceptContainer.swift
//  project
//
//  Created by Salome Poulain on 14/12/2023.
//

import Foundation
import SwiftData

actor ReceptenContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let schema = Schema([
            ReceptItem.self,
            IngredientItem.self,
            User.self
        ])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if shouldCreateDefaults {
            
            let ingredienten = IngredientenJSONDecoder.decode(from: "StandaardIngredienten")
            if !ingredienten.isEmpty {
                ingredienten.forEach { item in
                    let ingredient = IngredientItem(naam: item.naam)
                    container.mainContext.insert(ingredient)
                }
            }
            
            let newUser = User(id: 1, startDay: 0)
            container.mainContext.insert(newUser)
            
            shouldCreateDefaults = false
        }
        return container
    }
    
}   
