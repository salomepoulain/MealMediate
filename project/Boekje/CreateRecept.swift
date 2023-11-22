//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct CreateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ReceptItem()
    
    var body: some View {
        List {
            TextField("Naam", text: $item.naam)
            Toggle("Gezond?", isOn: $item.isGezond)
            Toggle("Makkelijk?", isOn: $item.isMakkelijk)
            TextField("Tijd", text: $item.tijd)
            TextField("Ingredient", text: $item.ingredienten)
            TextField("Uitleg", text: $item.uitleg)
            Button("Create") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .navigationTitle("Creëer recept")
    }
}

#Preview {
    CreateRecept()
        .modelContainer(for: ReceptItem.self)
}

