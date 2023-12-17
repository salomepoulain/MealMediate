//
//  IngredientenModel.swift
//  project
//
//  Created by Salome Poulain on 01/12/2023.
//

import Foundation
import SwiftData

// MARK: - IngredientItem

@Model
class IngredientItem {
    
    @Attribute(.unique)
    var naam: String
    
    var isKlaar: Bool = false
    
    @Relationship
    var recepten: [ReceptItem]?
    
    init(naam: String, isKlaar: Bool = false) {
        self.naam = naam
        self.isKlaar = isKlaar
    }
}
