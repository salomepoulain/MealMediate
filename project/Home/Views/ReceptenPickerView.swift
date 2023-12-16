//
//  ReceptenPickerView.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI
import SwiftData

struct ReceptenPickerView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var recepten: [ReceptItem]
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]

    
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
    
    @State private var localSelectedRecept: ReceptItem?
    @Binding var selectedRecept: ReceptItem?

    
    var body: some View {
        
        
        NavigationStack {
        
            ScrollView {
                
                HStack {

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
                    .padding([.bottom, .top], 20)
                    
                    Button {
                        withAnimation {
                            showFilterSheet.toggle()
                        }
                    } label: {
                        Label("Filter", systemImage: areFiltersDefault() ? "line.3.horizontal" : "line.3.horizontal.decrease")
                            .foregroundColor(areFiltersDefault() ? .white : Color.accentColor)
                            .padding()
                    }
                    .padding([.bottom, .top], 20)
                }
                

                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    
                    ForEach(filteredRecepten) { recept in
                        TilePickerView(receptItem: recept)
                            .onTapGesture {
                                localSelectedRecept = recept
                            }
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(localSelectedRecept == recept ? Color.accentColor : Color.clear, lineWidth: 3)
                                    .background(localSelectedRecept == recept ? Color.accentColor.opacity(0.05) : Color.clear)
                                    .shadow(color: localSelectedRecept == recept ? Color.accentColor.opacity(0.5) : Color.clear, radius: 3)
                            )
                    }
                }
                .padding()
            }
            .searchable(text: $searchQuery, prompt: "Zoek recept of ingrediënt")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(localSelectedRecept != nil ? "\(localSelectedRecept!.naam)" : "Selecteer een gerecht")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        localSelectedRecept = nil
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedRecept = localSelectedRecept
                        dismiss()
                    }, label: {
                        Text("Voeg toe")
                    })
                }
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

