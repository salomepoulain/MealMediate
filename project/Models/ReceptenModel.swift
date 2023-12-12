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
    
    var weekDag: [Int]?
    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Relationship(deleteRule: .nullify, inverse: \IngredientItem.recepten)
    var ingredienten: [IngredientItem]?
    
    init(
        naam: String = "",
        isGezond: Bool = false,
        lekker: Int = 2,
        isVega: Bool = false,
        tijd: Int = 0,
        porties: Int = 1,
        uitleg: [String] = [""],
        isBoodschap: Bool = false,
        weekDag: [Int]? = nil,
        image: Data? = nil
    ) {
        self.naam = naam
        self.isGezond = isGezond
        self.lekker = lekker
        self.isVega = isVega
        self.tijd = tijd
        self.uitleg = uitleg
        self.porties = porties
        self.isBoodschap = isBoodschap
        self.weekDag = weekDag
        self.image = image
    }
}

extension ReceptItem {
    func copy() -> ReceptItem {
        return ReceptItem(
            naam: self.naam,
            isGezond: self.isGezond,
            lekker: self.lekker,
            isVega: self.isVega,
            tijd: self.tijd,
            porties: self.porties,
            uitleg: self.uitleg,
            isBoodschap: self.isBoodschap,
            weekDag: self.weekDag ?? [],
            image: self.image ?? Data()
        )
    }
}




