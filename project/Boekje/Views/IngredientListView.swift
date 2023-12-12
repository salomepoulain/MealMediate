//
//  IngredientListView.swift
//  project
//
//  Created by Salome Poulain on 01/12/2023.
//

import SwiftUI
import SwiftData

struct IngredientListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
    
    @State var IngredientText = ""
    @State private var searchQuery = ""
    @State private var searchedText: String = ""

    
    @State var tempSelected: [IngredientItem]?
    @Binding var selectedIngredienten: [IngredientItem]?
    
    var filteredIngredienten: [IngredientItem] {
        
        if searchQuery.isEmpty{
            return allIngredienten
        }
        
        let filteredIngredienten = allIngredienten.compactMap { item in
            let naamContainsQuery = item.naam.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            
            // let ingredientNaamContainsQuery = item.ingredienten?.naam.range(of: searchQuery, options:
                                                                               // .caseInsensitive) != nil
            return naamContainsQuery ? item : nil
        }
        
        return filteredIngredienten
    }

    
    var body: some View {
        
        NavigationStack {
            List {
                
                if let selectedIngredients = tempSelected {
                    DisclosureGroup("Gekozen ingrediënten (\(selectedIngredients.count))") {
                        ForEach(allIngredienten) { ingredient in
                            if selectedIngredients.contains(where: { $0.id == ingredient.id }) {
                                HStack {
                                    Text(ingredient.naam)
                                    Spacer()
                                    Image(systemName: "minus")
                                        .foregroundColor(Color.accentColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleSelectedIngredienten(ingredient)
                                }
                            }
                        }
                    }
                }
                
                    
                
                Section {
                    TextField("Voeg nieuw ingrediënt toe", text: $IngredientText, axis: .vertical)
                        .onChange(of: searchQuery) {
                            if filteredIngredienten.isEmpty {
                                IngredientText = searchQuery
                            }
                        }

                    if !IngredientText.isEmpty {
                        Button {
                            createIngredient()
                        } label: {
                            Label("Voeg nieuw ingredient toe..", systemImage: "plus.app.fill")
                                .foregroundColor(Color.accentColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }

                
                Section(header: Text("Alle ingrediënten")) {
                    ForEach(filteredIngredienten) { ingredient in
                        HStack {
                            Text(ingredient.naam)
                            if tempSelected?.contains(where: { $0.id == ingredient.id }) == true {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleSelectedIngredienten(ingredient)
                        }
                    }
                    .onDelete { indexSet in
                        deleteItems(at: indexSet)
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Zoek ingredient")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        allIngredienten.forEach { ingredient in
                            tempSelected = []
                        }
                        
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedIngredienten = tempSelected
                        
                        dismiss()
                        
                    }, label: {
                        Text("Voeg toe")
                    })
                }
            }
        }
        .onAppear(perform: {
            tempSelected = selectedIngredienten
        })
        
        
    }
    
    func toggleSelectedIngredienten(_ ingredient: IngredientItem) {
        if var selectedIngredients = tempSelected {
            if let index = selectedIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                // Ingredient is in the array, remove it
                selectedIngredients.remove(at: index)
            } else {
                // Ingredient is not in the array, add it
                selectedIngredients.append(ingredient)
            }
            tempSelected = selectedIngredients
        } else {
            // The array is nil, create a new array with the ingredient
            tempSelected = [ingredient]
        }
    }
    
    func deleteItems(at indices: IndexSet) {
        indices.forEach { index in
            let deletedIngredient = allIngredienten[index]
            
            // Remove the item from tempSelected
            tempSelected?.removeAll { $0.id == deletedIngredient.id }
            
            // Remove the item from selectedIngredients
            selectedIngredienten?.removeAll { $0.id == deletedIngredient.id }
            
            context.delete(deletedIngredient)
        }
        try? context.save()
    }
    
    func createIngredient() {
        guard !IngredientText.isEmpty else { return }

        let ingredient = IngredientItem(naam: IngredientText)
        context.insert(ingredient)
        try? context.save()
        IngredientText = ""
    }
}


