//
//  Receptenboekje.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct Boekje: View {
    
    // MARK: - Properties
    
    // Injecting the Core Data managed object context
    @Environment(\.modelContext) var context
    
    // State variables
    @State private var showCreate = false
    @State private var receptEdit: ReceptItem?
    
    // Query to fetch ReceptItems from Core Data
    @Query private var recepten: [ReceptItem]
    
    // Grid layout configuration
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    // State variables for filtering
    @State private var showFilterSheet = false
    @State private var searchQuery = ""
    @StateObject private var filterViewModel = FilterViewModel(
        defaultSortOption: .naam,
        defaultSortOrder: .ascending,
        defaultIsVegaFilter: false,
        defaultIsGezondFilter: false
    )

    // Computed property to get filtered ReceptItems
    var filteredRecepten: [ReceptItem] {
        let sortedRecepten = recepten.sort(on: filterViewModel.selectedSortOption, order: filterViewModel.sortOrder)
        
        return sortedRecepten.filterRecepten(
            searchQuery: searchQuery,
            isVegaFilter: filterViewModel.isVegaFilter,
            isGezondFilter: filterViewModel.isGezondFilter
        )
    }

    // MARK: - Body View

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    // Displaying each ReceptItem in a TileView
                    ForEach(filteredRecepten) { recept in
                        NavigationLink {
                            // Navigate to ReceptFinishedView when tapped
                            ReceptFinishedView(receptItem: recept)
                        } label: {
                            // TileView to display ReceptItem
                            TileView(receptItem: recept, backgroundColor: Color("Tile"))
                                .contextMenu {
                                    // Context menu options for each Tile
                                    Button {
                                        // Edit action
                                        receptEdit = recept
                                    } label: {
                                        Label("Wijzig", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
                                        // Delete action
                                        withAnimation {
                                            context.delete(recept)
                                        }
                                    } label: {
                                        Label("Verwijder", systemImage: "trash.fill")
                                    }
                                }
                                .shadow(color: Color.black.opacity(0.3), radius: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .searchable(text: $searchQuery, prompt: "Zoek op gerecht of ingredient")
            .navigationTitle("Receptenboekje")
            .toolbar {
                ToolbarItem {
                    // Button to toggle the filter sheet
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Image(systemName: filterViewModel.areFiltersDefault ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
                
                ToolbarItem {
                    // Button to add a new item
                    Button {
                        showCreate.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreate) {
                // Sheet to create a new ReceptItem
                CreateRecept()
            }
            .sheet(item: $receptEdit) { item in
                // Sheet to update an existing ReceptItem
                UpdateRecept(recept: item)
            }
            .sheet(isPresented: $showFilterSheet) {
                // Sheet to display filter options
                FilterSheetView(filterViewModel: filterViewModel)
            }
        }
    }
}
