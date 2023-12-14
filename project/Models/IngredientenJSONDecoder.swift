//
//  IngredientenJSONDecoder.swift
//  project
//
//  Created by Salome Poulain on 14/12/2023.
//

import Foundation

struct IngredientenResponse: Decodable {
    let naam: String
}

struct IngredientenJSONDecoder {
    
    static func decode(from fileName: String) -> [IngredientenResponse] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let ingredienten = try? JSONDecoder().decode([IngredientenResponse].self, from: data) else {
            return []
        }
        
        return ingredienten
    }
}
