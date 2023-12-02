//
//  IngredientenModel.swift
//  project
//
//  Created by Salome Poulain on 01/12/2023.
//

import Foundation
import SwiftData

@Model
class IngredientItem {
    @Attribute(.unique) var naam: String
    
    @Relationship var recepten: [ReceptItem]?
    
    @Attribute(.ephemeral) var isChecked = false
    
    init(naam: String, isChecked: Bool = false) {
        self.naam = naam
        self.isChecked = isChecked
    }
}
