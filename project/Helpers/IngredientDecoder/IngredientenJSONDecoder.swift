//
//  IngredientenJSONDecoder.swift
//  project
//
//  Created by Salome Poulain on 14/12/2023.
//

import Foundation

// MARK: - IngredientenResponse

// A Decodable structure representing the response format for ingredient data in JSON.
struct IngredientenResponse: Decodable {
    let naam: String
}

// MARK: - IngredientenJSONDecoder

// A utility struct responsible for decoding ingredient data from a JSON file.
struct IngredientenJSONDecoder {
    
    // Decodes ingredient data from a JSON file.
    // Parameter fileName: The name of the JSON file (without extension) containing ingredient data.
    // Returns: An array of `IngredientenResponse` objects decoded from the JSON file.
    static func decode(from fileName: String) -> [IngredientenResponse] {
        
        // Check if the JSON file exists and decode its content
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let ingredienten = try? JSONDecoder().decode([IngredientenResponse].self, from: data) else {
            return []
        }
        
        return ingredienten
    }
}
