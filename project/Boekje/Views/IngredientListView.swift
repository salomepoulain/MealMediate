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
    
    @State private var deletedIngredients: [IngredientItem] = []

    @State private var newIngredients: [IngredientItem] = []
    
    var allIngredients: [IngredientItem] {
        return allIngredienten + newIngredients
    }

    var filteredIngredienten: [IngredientItem] {
        if searchQuery.isEmpty {
            return allIngredients
        }

        let filteredIngredienten = allIngredients.compactMap { item in
            let naamContainsQuery = item.naam.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            return naamContainsQuery ? item : nil
        }
        return filteredIngredienten
    }

    
    var body: some View {
        
        NavigationStack {
            List {
                
                if let selectedIngredients = tempSelected {
                    DisclosureGroup("Gekozen ingrediënten (\(selectedIngredients.count))") {
                        ForEach(selectedIngredients, id: \.id) { ingredient in
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

                
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.secondary)
                            .frame(width: 20, height: 20)

                        TextField("Zoek ingredient of voeg nieuw toe", text: $searchQuery)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.clear)
                            .padding(.horizontal, 10)
                            .lineLimit(1)
                            .onChange(of: searchQuery) {
                                if filteredIngredienten.isEmpty {
                                    IngredientText = searchQuery
                                } else {
                                    IngredientText = ""
                                }
                            }

                        if !searchQuery.isEmpty {
                            Button {
                                searchQuery = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.secondary)
                                    .frame(width: 20, height: 20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    if !IngredientText.isEmpty {
                        Button {
                            createIngredient()
                        } label: {
                            Label("Voeg nieuw ingredient toe", systemImage: "plus.app.fill")
                                .foregroundColor(Color.accentColor)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                
                Section(header: Text("Alle ingrediënten")) {
                    ForEach(filteredIngredienten) { ingredient in
                        if !deletedIngredients.contains(ingredient) {
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
                    }
                    .onDelete { indexSet in
                        handleDeleteIngredients(at: indexSet)
                    }
                }

            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        allIngredienten.forEach { ingredient in
                            tempSelected = nil
                        }
                        deletedIngredients = []
                        
                        dismiss()
                    }, label: {
                        Text("Terug")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        performContextDeletion()
                        saveNewIngredients()
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
                selectedIngredients.remove(at: index)
            } else {
                selectedIngredients.append(ingredient)
            }
            tempSelected = selectedIngredients
        } else {
            tempSelected = [ingredient]
        }

    }
    
    func saveNewIngredients() {
        for newIngredient in newIngredients {
            context.insert(newIngredient)
        }
        try? context.save()
        newIngredients.removeAll()
    }

    func createIngredient() {
        guard !IngredientText.isEmpty else { return }

        let ingredient = IngredientItem(naam: IngredientText)
        newIngredients.append(ingredient)
        
        toggleSelectedIngredienten(ingredient)
        
        IngredientText = ""
        searchQuery = ""
    }
    
    func performContextDeletion() {
        for deletedIngredient in deletedIngredients {
            if let ingredientIndexInAll = allIngredienten.firstIndex(where: { $0.id == deletedIngredient.id }) {
                context.delete(allIngredienten[ingredientIndexInAll])
            }
        }

        try? context.save()

        deletedIngredients.removeAll()
    }

    
    func handleDeleteIngredients(at indices: IndexSet) {
        indices.forEach { index in
            let ingredientToDelete = filteredIngredienten[index]

            if let selectedIngredientIndex = tempSelected?.firstIndex(where: { $0.id == ingredientToDelete.id }) {
                tempSelected?.remove(at: selectedIngredientIndex)
            }

            if let newIngredientIndex = newIngredients.firstIndex(where: { $0.id == ingredientToDelete.id }) {
                newIngredients.remove(at: newIngredientIndex)
            }

            deletedIngredients.append(ingredientToDelete)

        }
        
        try? context.save()
    }
}


