//
//  UpdateRecept.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import SwiftData

struct UpdateRecept: View {
    
    // MARK: - Properties
    
    // Bindable property to hold the ReceptItem being updated
    @Bindable var recept: ReceptItem
    
    // State variable for the navigation title
    @State private var title = "Wijzig"
    
    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            // ReceptFormView to display and update information for the ReceptItem
            ReceptFormView(item: recept, title: $title)
                .navigationTitle("Wijzig recept")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
