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
    
    enum Order {
        case ascending
        case descending
    }
    
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
    @State private var sortOrder: SortOption.Order = .ascending
    
    @State private var selectedSortOption = SortOption.allCases.first!
    
    @State private var isVegaFilter = false
    @State private var isGezondFilter = false
    
    @State private var defaultSortOption: SortOption = .naam
    @State private var defaultSortOrder: SortOption.Order = .ascending
    @State private var defaultIsVegaFilter = false
    @State private var defaultIsGezondFilter = false
    
    var filteredRecepten: [ReceptItem] {
        
        if searchQuery.isEmpty && !isVegaFilter && !isGezondFilter {
            return recepten.sort(on: selectedSortOption, order: sortOrder)
        }
        
        let filteredRecepten = recepten.filter { item in
            let naamContainsQuery = item.naam.range(of: searchQuery, options: .caseInsensitive) != nil

            let ingredientNaamContainsQuery = item.ingredienten?.contains(where: { ingredient in
                ingredient.naam.range(of: searchQuery, options: .caseInsensitive) != nil
            }) ?? false

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
            
            let isVegaQuery: Bool
            if isVegaFilter && isGezondFilter {
                isVegaQuery = item.isVega && item.isGezond
            } else {
                isVegaQuery = item.isVega && isVegaFilter
            }

            let isGezondQuery: Bool
            if isVegaFilter && isGezondFilter {
                isGezondQuery = item.isVega && item.isGezond
            } else {
                isGezondQuery = item.isGezond && isGezondFilter
            }

            return naamContainsQuery || ingredientNaamContainsQuery || isVegaQuery || isGezondQuery || lekkerContainsQuery
        }


            return filteredRecepten.sort(on: selectedSortOption, order: sortOrder)
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
            .sheet(isPresented: $showCreate){
                CreateRecept()
            }
            .sheet(item: $ReceptEdit) {
                ReceptEdit = nil
            } content: { item in
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
    
    func sort(on option: SortOption, order: SortOption.Order) -> [ReceptItem] {
        let sortedArray = sort(on: option)
        return order == .ascending ? sortedArray : sortedArray.reversed()
    }
}

