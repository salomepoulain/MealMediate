//
//  IngredientListView.swift
//  project
//
//  Created by Salome Poulain on 01/12/2023.
//

import SwiftUI
import SwiftData

struct IngredientListView: View {
    // MARK: - Environment Variables
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    // Query for fetching all ingredients sorted by name
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
    
    // State variables
    @State var IngredientText = ""
    @State private var searchQuery = ""
    @State private var searchedText: String = ""
    
    // Binding variable for selected ingredients
    @Binding var selectedIngredienten: [IngredientItem]?
    
    // Temporary selected ingredients
    @State var tempSelected: [IngredientItem]?
    
    // Arrays to track deleted and new ingredients
    @State private var deletedIngredients: [IngredientItem] = []
    @State private var newIngredients: [IngredientItem] = []
    
    // Computed property for all ingredients excluding deleted and new ones
    var allIngredients: [IngredientItem] {
        let ingredientsWithoutDeleted = allIngredienten.filter { !deletedIngredients.contains($0) }
        return ingredientsWithoutDeleted + newIngredients
    }

    // Computed property for filtered ingredients based on the search query
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

    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            List {
                
                // Display selected ingredients in a DisclosureGroup
                if let selectedIngredients = tempSelected {
                    DisclosureGroup("Gekozen ingrediënten (\(selectedIngredients.count))") {
                        ForEach(selectedIngredients, id: \.id) { ingredient in
                            IngredientRowView(ingredient: ingredient) {
                                toggleSelectedIngredienten(ingredient)
                            }
                        }
                    }
                }
                
                // Search and Add section
                Section {
                    SearchAndAddView(
                        searchQuery: $searchQuery,
                        ingredientText: $IngredientText,
                        onSearchQueryChange: {
                            if filteredIngredienten.isEmpty {
                                IngredientText = searchQuery
                            } else {
                                IngredientText = ""
                            }
                        },
                        onClearSearch: {
                            searchQuery = ""
                        },
                        onCreateIngredient: {
                            createIngredient()
                        }
                    )
                }
                
                // Display all ingredients in a section
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
                        handleDeleteIngredients(at: indexSet)
                    }
                }

            }
            .toolbar{
                // Toolbar items for navigation bar
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
    
    // MARK: - Helper functions
    
    // Function to toggle the selection of an ingredient
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
    
    // Function to save new ingredients to the context
    func saveNewIngredients() {
        for newIngredient in newIngredients {
            context.insert(newIngredient)
        }
        try? context.save()
        newIngredients.removeAll()
    }

    // Function to create a new ingredient
    func createIngredient() {
        guard !IngredientText.isEmpty else { return }

        let ingredient = IngredientItem(naam: IngredientText)
        newIngredients.append(ingredient)
        toggleSelectedIngredienten(ingredient)
        IngredientText = ""
        searchQuery = ""
    }
    
    // Function to perform deletion of ingredients from the context
    func performContextDeletion() {
        for deletedIngredient in deletedIngredients {
            if let ingredientIndexInAll = allIngredienten.firstIndex(where: { $0.id == deletedIngredient.id }) {
                context.delete(allIngredienten[ingredientIndexInAll])
            }
        }
        try? context.save()
        deletedIngredients.removeAll()
    }

    // Function to handle deletion of ingredients
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

// MARK: - Views

// Struct for displaying an ingredient row
struct IngredientRowView: View {
    var ingredient: IngredientItem
    var onTap: () -> Void

    var body: some View {
        HStack {
            Text(ingredient.naam)
            Spacer()
            Image(systemName: "minus")
                .foregroundColor(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// Struct for the Search and Add section
struct SearchAndAddView: View {
    @Binding var searchQuery: String
    @Binding var ingredientText: String
    var onSearchQueryChange: () -> Void
    var onClearSearch: () -> Void
    var onCreateIngredient: () -> Void

    var body: some View {
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
                    onSearchQueryChange()
                }

            if !searchQuery.isEmpty {
                Button {
                    onClearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.secondary)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }

        if !ingredientText.isEmpty {
            Button {
                onCreateIngredient()
            } label: {
                Label("Voeg nieuw ingredient toe", systemImage: "plus.app.fill")
                    .foregroundColor(Color.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
