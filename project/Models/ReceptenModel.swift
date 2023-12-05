//
//  ReceptenModel.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import Foundation
import SwiftData

@Model
final class ReceptItem {
    @Attribute(.unique) var naam: String
    var isGezond: Bool
    var lekker: Int
    var isVega: Bool
    var tijd: Int
    var porties: Int
    var uitleg: [String]
    var isBoodschap: Bool
    
    @Attribute(.externalStorage)
    var image: Data?
        
    @Relationship(deleteRule: .nullify, inverse: \IngredientItem.recepten)
    var ingredienten: [IngredientItem]?
    
    init(naam: String = "", isGezond: Bool = false, lekker: Int = 2, isVega: Bool = false, tijd: Int = 0, porties: Int = 1, uitleg: [String] = [""], isBoodschap: Bool = false) {
        self.naam = naam
        self.isGezond = isGezond
        self.lekker = lekker
        self.isVega = isVega
        self.tijd = tijd
        self.uitleg = uitleg
        self.porties = porties
        self.isBoodschap = isBoodschap
    }
}

