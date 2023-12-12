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
    
    
    @State private var searchQuery = ""
    
    @State private var localSelectedRecept: ReceptItem?
    @Binding var selectedRecept: ReceptItem?

    
    var filteredRecepten: [ReceptItem] {
        
        if searchQuery.isEmpty{
            return recepten
        }
        
        let filteredRecepten = recepten.compactMap { item in
            let naamContainsQuery = item.naam.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            return naamContainsQuery ? item : nil
        }
        
        return filteredRecepten
    }

    
    var body: some View {
        
        
        NavigationStack {
        
            ScrollView {
                
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
            .searchable(text: $searchQuery, prompt: "Zoek recept")
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
        }

    }
}

