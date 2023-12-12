//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct CreateRecept: View {
    
    @Environment(\.modelContext) var context
    @State private var recept = ReceptItem()
    
    @State private var title = "Voeg toe"
    
    var body: some View {
        
        NavigationStack {
            ReceptFormView(item: recept, title: $title)
                .navigationTitle("Creëer recept")
                .navigationBarTitleDisplayMode(.inline)
                
        }
    }
}

#Preview {
    CreateRecept()

}
