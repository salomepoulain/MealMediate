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
    
    var body: some View {
        
        NavigationStack {
            List {
                
                Section(header: Text("Geselecteerde ingredienten")){
                    ForEach(allIngredienten) { ingredient in
                        if ingredient.isChecked {
                            HStack {
                                Text(ingredient.naam)
                                Spacer()
                                Image(systemName: "minus")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                ingredient.isChecked.toggle()
                            }
                        }
                    }
                }
                
                Section {
                    DisclosureGroup("Voeg ingredient toe") {
                        TextField("Zoals: \"Cherry Tomaten\"", text: $IngredientText, axis: .vertical)
                        
                        Button("Save") {
                            createIngredient()
                        }
                    }
                }
                
                Section(header: Text("Alle ingredienten")) {
                    ForEach(allIngredienten) { ingredient in
                        HStack {
                            Text(ingredient.naam)
                            if ingredient.isChecked {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            ingredient.isChecked.toggle()
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
            
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
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
        let ingredient = IngredientItem(naam: IngredientText, recepten: [])
        context.insert(ingredient)
        try? context.save()
        IngredientText = ""
    }
}

#Preview {
    IngredientListView()
}

