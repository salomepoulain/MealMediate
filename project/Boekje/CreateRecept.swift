//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct CreateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var recept = ReceptItem()
    
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
    
    @State private var isNameEntered: Bool = false
    @State private var isImageAdded: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ReceptListView(item: recept, isNameEntered: $isNameEntered, isImageAdded: $isImageAdded)
                .navigationTitle("Creëer recept")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button (action: {
                            allIngredienten.forEach { ingredient in
                                ingredient.isChecked = false
                            }
                            
                            dismiss()
                        }, label: {
                            Text("Sluit")
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                            var ingredienten = [IngredientItem]()
                            allIngredienten.forEach { ingredient in
                                if ingredient.isChecked {
                                    ingredienten.append(ingredient)
                                    ingredient.isChecked = false
                                }
                            }
                            recept.ingredienten = ingredienten
                            
                            withAnimation {
                                context.insert(recept)
                            }
                            dismiss()
                        }, label: {
                            Text("Voeg toe")
                                .foregroundColor(isImageAdded && isNameEntered ? Color.accentColor : Color.gray)
                        })
                        .disabled(!(isNameEntered && isImageAdded))
                    }
            }
        }
    }
}

#Preview {
    CreateRecept()

}
