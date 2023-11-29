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
    var naam: String
    var isGezond: Bool
    var lekker: Int
    var isVega: Bool
    var tijd: Int
    var ingredienten: String
    var uitleg: String
    
    init(naam: String = "", isGezond: Bool = false, lekker: Int = 0, isVega: Bool = false, tijd: Int = 0, ingredienten: String = "", uitleg: String = "") {
        self.naam = naam
        self.isGezond = isGezond
        self.lekker = lekker
        self.isVega = isVega
        self.tijd = tijd
        self.ingredienten = ingredienten
        self.uitleg = uitleg
    }
}

