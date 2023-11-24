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
            Toggle("Vega?", isOn: $item.isVega)
            Stepper("Rating: \(item.lekker)", value: $item.lekker, in: 1...3)
            Stepper("Tijd: \(item.tijd*10) minuten", value: $item.tijd, in: 1...30)
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

