//
//  Boodschappen.swift
//  project
//
//  Created by Salome Poulain on 05/12/2023.
//

import SwiftUI
import SwiftData

struct Boodschappen: View {
    
    // MARK: - Environment Variables
    
    @Environment(\.modelContext) private var context
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
        
    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(allIngredienten) { ingredient in
                    // Check if the ingredient has associated recipes
                    if let recepten = ingredient.recepten, recepten.count > 0 {
                        // Filter recipes to include only those marked as "Boodschap"
                        let filteredRecepten = recepten.filter { $0.isBoodschap }
                        
                        // Show DisclosureGroup only if there are filtered recipes
                        if !filteredRecepten.isEmpty {
                            DisclosureGroup {
                                // Display each recipe with a navigation link
                                ForEach(filteredRecepten) { recept in
                                    NavigationLink {
                                        ReceptFinishedView(receptItem: recept)
                                    } label: {
                                        HStack {
                                            Spacer()
                                            ReceptNavigationlinkView(receptItem: recept)
                                        }
                                    }
                                    .deleteDisabled(true)
                                }
                            } label: {
                                // Use a custom view for the ingredient toggle button
                                IngredientToggleButton(ingredient: ingredient, filteredRecepten: filteredRecepten)
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
            }
            .toolbar {
                // Toolbar with a menu for clearing all items
                Menu {
                    // Button to clear all items and associated recipes
                    Button(role: .destructive) {
                        allIngredienten.forEach { ingredient in
                            ingredient.isKlaar = false
                            
                            ingredient.recepten?.forEach { recept in
                                recept.isBoodschap = false
                            }
                        }
                    } label: {
                        Label("Leeg alles", systemImage: "trash.fill")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
            .navigationTitle("Boodschappen")
        }
    }
}

// MARK: - View

// Custom view for the toggle button associated with an ingredient
struct IngredientToggleButton: View {
    var ingredient: IngredientItem
    var filteredRecepten: [ReceptItem]
    
    var body: some View {
        Button {
            ingredient.isKlaar.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: ingredient.isKlaar ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(Color.accentColor)
                    .padding(.trailing, 3)

                Text("(\(filteredRecepten.count))  \(ingredient.naam)")
                    .padding([.leading, .trailing], 2)
                    .foregroundColor(ingredient.isKlaar ? .gray : .primary)
                    .overlay(
                        ingredient.isKlaar ?
                            Rectangle()
                                .frame(height: 2)
                                .offset(y: 2)
                                .foregroundColor(.gray) :
                            nil
                    )
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}


// Custom view for the navigationlink
struct ReceptNavigationlinkView: View {
    var receptItem: ReceptItem

    var body: some View {
        
        HStack {
            if !receptItem.image.isEmpty {
                let uiImage = UIImage(data: receptItem.image)
                Image(uiImage: uiImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                    .clipShape(Rectangle())
                    .padding(.trailing, 5)
            }
            
            Text(receptItem.naam)
                .lineLimit(2)

            Spacer()
        }
        .frame(width: 240)
        
    }
}
