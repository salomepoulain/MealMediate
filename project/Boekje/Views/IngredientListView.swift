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
    @State var selectedItems: Int = 0
    
    @State private var searchQuery = ""
    
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
                
                Section {
                    DisclosureGroup("Gekozen ingrediënten (\(selectedItems))") {
                        ForEach(allIngredienten) { ingredient in
                            if ingredient.isChecked {
                                HStack {
                                    Text(ingredient.naam)
                                    Spacer()
                                    Image(systemName: "minus")
                                        .foregroundColor(Color.accentColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    ingredient.isChecked.toggle()
                                }
                            }
                        }
                    }
                }
                
                    
                
                Section {
                    DisclosureGroup("Voeg nieuw ingrediënt toe") {
                        TextField("Zoals: \"Cherry Tomaten\"", text: $IngredientText, axis: .vertical)
                        
                        Button("Voeg toe") {
                            createIngredient()
                        }
                    }
                }
                
                Section(header: Text("Alle ingrediënten")) {
                    ForEach(filteredIngredienten) { ingredient in
                        HStack {
                            Text(ingredient.naam)
                            if ingredient.isChecked {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            ingredient.isChecked.toggle()
                        }
                        .onChange(of: ingredient.isChecked) {
                            selectedItems = allIngredienten.filter { $0.isChecked }.count
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            context.delete(allIngredienten[index])
                        }
                        try? context.save()
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Zoek ingredient")
            .toolbar{
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
                        
                        dismiss()
                        
                    }, label: {
                        Text("Voeg toe")
                    })
                }
            }
        }
        
        
    }
    
    func createIngredient() {
        let ingredient = IngredientItem(naam: IngredientText)
        context.insert(ingredient)
        try? context.save()
        IngredientText = ""
    }
}


