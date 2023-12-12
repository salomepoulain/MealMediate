//
//  UpdateRecept.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import SwiftData
struct UpdateRecept: View {
    
    @Bindable var recept: ReceptItem
    
    @State private var title = "Wijzig"
    
    var body: some View {
        NavigationStack {
            ReceptFormView(item: recept, title: $title)
                .navigationTitle("Wijzig recept")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}


