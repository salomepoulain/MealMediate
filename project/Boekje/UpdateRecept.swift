//
//  UpdateRecept.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import SwiftData
struct UpdateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Bindable var recept: ReceptItem
    
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
    
    var body: some View {
        NavigationStack {
            UpdateReceptFormView(item: recept)
                .navigationTitle("Wijzig recept")
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
                        Button (action: {
                            
                            var ingredienten = [IngredientItem]()
                            allIngredienten.forEach { ingredient in
                                if ingredient.isChecked {
                                    ingredienten.append(ingredient)
                                    ingredient.isChecked = false
                                }
                            }
                            recept.ingredienten = ingredienten
                            
                            dismiss()
                        }, label: {
                            Text("Wijzig")
                        })
                    }
                }
        }
    }
}


