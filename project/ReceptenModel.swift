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
    var isMakkelijk: Bool
    var tijd: String
    var ingredienten: String
    var uitleg: String
    
    init(naam: String = "", isGezond: Bool = false, isMakkelijk: Bool = false, tijd: String = "", ingredienten: String = "", uitleg: String = "") {
        self.naam = naam
        self.isGezond = isGezond
        self.isMakkelijk = isMakkelijk
        self.tijd = tijd
        self.ingredienten = ingredienten
        self.uitleg = uitleg
    }
}

