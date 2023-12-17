//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct CreateRecept: View {
    
    // MARK: - Properties
    
    // Injecting the Core Data managed object context
    @Environment(\.modelContext) var context
    
    // State variable to hold the new ReceptItem
    @State private var recept = ReceptItem()
    
    // State variable for the navigation title
    @State private var title = "Voeg toe"
    
    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            // ReceptFormView to gather information for the new ReceptItem
            ReceptFormView(item: recept, title: $title)
                .navigationTitle("Creëer recept")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
