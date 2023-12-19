//
//  ReceptenPickerView.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI
import SwiftData

struct ReceptenPickerView: View {
    // Environment Variables
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    // Query Variables
    @Query private var recepten: [ReceptItem]
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]

    // Grid Configuration
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    // State Variables
    @State private var showFilterSheet = false
    @State private var searchQuery = ""
    @StateObject private var filterViewModel = FilterViewModel(
        defaultSortOption: .naam,
        defaultSortOrder: .ascending,
        defaultIsVegaFilter: false,
        defaultIsGezondFilter: false
    )

    // Computed Property for Filtered Recipes
    var filteredRecepten: [ReceptItem] {
        let sortedRecepten = recepten.sort(on: filterViewModel.selectedSortOption, order: filterViewModel.sortOrder)
        return sortedRecepten.filterRecepten(searchQuery: searchQuery, isVegaFilter: filterViewModel.isVegaFilter, isGezondFilter: filterViewModel.isGezondFilter)
    }
    
    // State for Selected Recipe (Local to this view)
    @State private var localSelectedRecept: ReceptItem?
    
    // Binding for Selected Recipe (Passed from parent view)
    @Binding var selectedRecept: ReceptItem?
    
    // MARK: - Body View
    var body: some View {
        NavigationStack {
            ScrollView {
                // Button Bar
                HStack {
                    randomSelectionButton
                        .padding([.bottom, .top], 20)

                    filterButton
                        .padding([.bottom, .top], 20)
                }
                
                // Grid to Display Filtered Recipes
                recipesGrid
                    .padding()
            }
            
            // Search Bar
            .searchable(text: $searchQuery, prompt: "Zoek recept of ingrediënt")
            
            // Navigation Bar Title
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(localSelectedRecept != nil ? "\(localSelectedRecept!.naam)" : "Selecteer een gerecht")
            
            // Toolbar
            .toolbar {
                // Close Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        localSelectedRecept = nil
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                // Add Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedRecept = localSelectedRecept
                        dismiss()
                    }, label: {
                        Text("Voeg toe")
                    })
                }
            }
            
            // Filter Sheet
            .sheet(isPresented: $showFilterSheet) {
                FilterSheetView(filterViewModel: filterViewModel)
            }
        }
    }

    // MARK: - Helper Variables
    
    // Recipe grid
    private var recipesGrid: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 20) {
            ForEach(filteredRecepten) { recept in
                // Display each recipe with tap gesture and selection overlay
                TileView(receptItem: recept, backgroundColor: Color("TileLight"))
                    .onTapGesture {
                        localSelectedRecept = recept
                    }
                    .shadow(color: Color("Shadow").opacity(0.4), radius: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(localSelectedRecept == recept ? Color.accentColor : Color.clear, lineWidth: 3)
                            .background(localSelectedRecept == recept ? Color.accentColor.opacity(0.05) : Color.clear)
                            .shadow(color: localSelectedRecept == recept ? Color.accentColor.opacity(0.5) : Color.clear, radius: 3)
                    )
            }
        }
    }
    
    // Random Selection Button
    private var randomSelectionButton: some View {
        Button {
            if let randomRecept = filteredRecepten.randomElement() {
                localSelectedRecept = randomRecept
            }
        } label: {
            Label("Selecteer willekeurig", systemImage: "dice.fill")
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
                .bold()
                .shadow(color: Color.accentColor.opacity(0.5), radius: 3)
        }
    }

    // Filter Button
    private var filterButton: some View {
        Button {
            withAnimation {
                showFilterSheet.toggle()
            }
        } label: {
            Label("Filter", systemImage: filterViewModel.areFiltersDefault ? "line.3.horizontal" : "line.3.horizontal.decrease")
                .foregroundColor(filterViewModel.areFiltersDefault ? .primary :Color.accentColor)
                .padding()
        }
    }
}
