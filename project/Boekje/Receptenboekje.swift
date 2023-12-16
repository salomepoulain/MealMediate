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
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var ReceptEdit: ReceptItem?
    
    @Query private var recepten: [ReceptItem]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var showFilterSheet = false
    
    @State private var searchQuery = ""
    @State private var sortOrder: SortOption.Order = .ascending
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    @State private var isVegaFilter = false
    @State private var isGezondFilter = false
    
    @State private var defaultSortOption: SortOption = .naam
    @State private var defaultSortOrder: SortOption.Order = .ascending
    @State private var defaultIsVegaFilter = false
    @State private var defaultIsGezondFilter = false
    
    var filteredRecepten: [ReceptItem] {
        let sortedRecepten = recepten.sort(on: selectedSortOption)
        return sortedRecepten.filterRecepten(searchQuery: searchQuery, isVegaFilter: isVegaFilter, isGezondFilter: isGezondFilter)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    ForEach(filteredRecepten) { recept in
                        NavigationLink {
                            ReceptFinishedView(receptItem: recept)
                        } label: {
                            TileView(receptItem: recept)
                                .contextMenu {
                                    Button{
                                        ReceptEdit = recept
                                    } label: {
                                        Label("Wijzig", systemImage: "pencil")
                                    }
                                    Button(role: .destructive) {
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
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Image(systemName: areFiltersDefault() ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                    }
                }
                
                ToolbarItem {
                    Button {
                        showCreate.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .foregroundColor(Color("AccentColor"))
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateRecept()
            }
            .sheet(item: $ReceptEdit) { item in
                UpdateRecept(recept: item)
            }
            .sheet(isPresented: $showFilterSheet) {
                NavigationStack {
                    List {
                        Section("Sorteren") {
                            Picker("Sorteren op", selection: $selectedSortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue.capitalized)
                                        .tag(option)
                                }
                            }
                            Picker("Volgorde", selection: $sortOrder) {
                                Text("Oplopend").tag(SortOption.Order.ascending)
                                Text("Aflopend").tag(SortOption.Order.descending)
                            }
                        }
                        Section("filter") {
                            Toggle("Gezond", isOn: $isGezondFilter)
                            Toggle("Vegetarisch", isOn: $isVegaFilter)
                        }
                        Section {
                            Button("Reset filters") {
                                if !areFiltersDefault() {
                                    // Reset filters to default values
                                    selectedSortOption = defaultSortOption
                                    sortOrder = defaultSortOrder
                                    isVegaFilter = defaultIsVegaFilter
                                    isGezondFilter = defaultIsGezondFilter
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(areFiltersDefault() ? .gray : .red)
                            .disabled(areFiltersDefault())
                        }
                    }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    func areFiltersDefault() -> Bool {
        return selectedSortOption == defaultSortOption &&
               sortOrder == defaultSortOrder &&
               isVegaFilter == defaultIsVegaFilter &&
               isGezondFilter == defaultIsGezondFilter
    }
}
