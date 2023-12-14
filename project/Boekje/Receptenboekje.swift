//
//  Receptenboekje.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case naam, tijd, lekker, porties
    
    var id: SortOption { self }
    
    var sortDescriptor: SortDescriptor<ReceptItem> {
        switch self {
        case .naam:
            return SortDescriptor(\ReceptItem.naam)
        case .tijd:
            return SortDescriptor(\ReceptItem.tijd)
        case .lekker:
            return SortDescriptor(\ReceptItem.lekker)
        case .porties:
            return SortDescriptor(\ReceptItem.porties)
        }
    }
}

struct Boekje: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var showFilterSheet = false
    
    @State private var ReceptEdit: ReceptItem?
    
    @Query private var recepten: [ReceptItem]

    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var isContextMenuVisible = false
    @State private var searchQuery = ""
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    @State private var isVegaFilter = false
    @State private var isGezondFilter = false
    
    var filteredRecepten: [ReceptItem] {
        
        if searchQuery.isEmpty && !isVegaFilter && !isGezondFilter {
            return recepten.sort(on: selectedSortOption)
        }
        
        let filteredRecepten = recepten.filter { item in
                let naamContainsQuery = item.naam.range(of: searchQuery, options: .caseInsensitive) != nil

                let ingredientNaamContainsQuery = item.ingredienten?.contains(where: { ingredient in
                    ingredient.naam.range(of: searchQuery, options: .caseInsensitive) != nil
                }) ?? false
            
                let isVegaContainsQuery = item.isVega && (searchQuery.lowercased() == "vega" || isVegaFilter)
                let isGezondContainsQuery = item.isGezond && (searchQuery.lowercased() == "gezond" || isGezondFilter)
            
                let lekkerContainsQuery: Bool
                switch searchQuery.lowercased() {
                case "ok":
                    lekkerContainsQuery = item.lekker == 1
                case "lekker":
                    lekkerContainsQuery = item.lekker == 2
                case "heerlijk":
                    lekkerContainsQuery = item.lekker == 3
                default:
                    lekkerContainsQuery = false
                }

                return naamContainsQuery || ingredientNaamContainsQuery || isVegaContainsQuery || isGezondContainsQuery || lekkerContainsQuery

                
            }

            return filteredRecepten.sort(on: selectedSortOption)
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
            .overlay {
                if filteredRecepten.isEmpty {
                    ContentUnavailableView.search
                }
            }
            .navigationTitle("Receptenboekje")
            .toolbar {
                
                ToolbarItem {
                    Button {
                        showFilterSheet.toggle()
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem {
                    Button {
                        showCreate.toggle()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreate){
                CreateRecept()
            }
            .sheet(item: $ReceptEdit) {
                ReceptEdit = nil
            } content: { item in
                UpdateRecept(recept: item)
            }
            .sheet(isPresented: $showFilterSheet) {
                List {
                    Picker("Sort by", selection: $selectedSortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }

                    Toggle("Gezond", isOn: $isVegaFilter)
                    Toggle("Vegetarisch", isOn: $isVegaFilter)
                    
                }
            }
        }

    }
}

private extension Array where Element == ReceptItem {
    
    func sort(on option: SortOption) -> [ReceptItem] {
        switch option {
        case .naam:
            return self.sorted(by: { $0.naam < $1.naam })
        case .tijd:
            return self.sorted(by: { $0.tijd < $1.tijd })
        case .lekker:
            return self.sorted(by: { $0.lekker < $1.lekker })
        case .porties:
            return self.sorted(by: { $0.porties < $1.porties })
        }
    }
}

