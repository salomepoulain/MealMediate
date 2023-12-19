//
//  DayReceptPickerView.swift
//  project
//
//  Created by Salome Poulain on 10/12/2023.
//

import SwiftUI
import SwiftData

struct DayReceptPickerView: View {
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
    
    // State Variables filtering
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
    
    // State for Selected Recipe
    @State private var selectedRecept: ReceptItem?
    
    // Binding for Selected Day
    @Binding var day: Int
    
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
            .navigationTitle(selectedRecept != nil ? "\(selectedRecept!.naam)" : "Selecteer een gerecht")
            
            // Toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                // Add Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addWeekDayToSelectedRecept(selectedRecept: $selectedRecept, day: day)
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

    // MARK: - Helper variabeles
    
    // Recipe grid
    private var recipesGrid: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 20) {
            ForEach(filteredRecepten) { recept in
                // Display each recipe with tap gesture and selection overlay
                TileView(receptItem: recept, backgroundColor: Color("TileLight"))
                    .onTapGesture {
                        selectedRecept = recept
                    }
                    .shadow(color: Color("Shadow").opacity(0.4), radius: 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedRecept == recept ? Color.accentColor : Color.clear, lineWidth: 3)
                            .background(selectedRecept == recept ? Color.accentColor.opacity(0.05) : Color.clear)
                            .shadow(color: selectedRecept == recept ? Color.accentColor.opacity(0.5) : Color.clear, radius: 3)
                    )
            }
        }
    }
    
    // Random Selection Button
    private var randomSelectionButton: some View {
        Button {
            if let randomRecept = filteredRecepten.randomElement() {
                selectedRecept = randomRecept
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
                .foregroundColor(filterViewModel.areFiltersDefault ? .primary : Color.accentColor)
                .padding()
        }
    }

    // MARK: - Function to Add Weekday to Selected Recipe
    private func addWeekDayToSelectedRecept(selectedRecept: Binding<ReceptItem?>, day: Int) {
        if let recept = selectedRecept.wrappedValue {
            if recept.weekDag == nil {
                recept.weekDag = [day]
            } else {
                recept.weekDag?.append(day)
            }
        }
    }
}
