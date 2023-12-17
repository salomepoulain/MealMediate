//
//  UserModel.swift
//  project
//
//  Created by Salome Poulain on 07/12/2023.
//

import Foundation
import SwiftData

// MARK: - User

@Model
class User {
    
    @Attribute(.unique)
    var id: Int
    
    var startDay: Int
    
    init(id: Int = 1, startDay: Int = 0) {
        self.id = id
        self.startDay = startDay
    }
}
