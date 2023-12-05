//
//  Receptenboekje.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct Boekje: View {
    
    @Environment(\.modelContext) var context
    
    @State private var showCreate = false
    @State private var ReceptEdit: ReceptItem?
    
    @Query private var recepten: [ReceptItem]
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]

    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var isContextMenuVisible = false
    @State private var showSuccessMessage = false
    
    @State private var searchQuery = ""
    
    var filteredRecepten: [ReceptItem] {
        
        if searchQuery.isEmpty{
            return recepten
        }
        
        let filteredRecepten = recepten.compactMap { item in
            let naamContainsQuery = item.naam.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            
            // let ingredientNaamContainsQuery = item.ingredienten?.naam.range(of: searchQuery, options: .caseInsensitive) != nil
            
            return naamContainsQuery ? item : nil
        }
        
        return filteredRecepten
    }

    
    var body: some View {
        
        
        NavigationStack {
        
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    
                    ForEach(filteredRecepten) { recept in
                        NavigationLink {
                            ReceptFinishedView(receptItem: recept)
                                .toolbar {
                                                                    
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Menu {
                                            Button {
                                                if let ingredienten = recept.ingredienten {
                                                    if ingredienten.isEmpty {
                                                        
                                                    }
                                                    else {
                                                        ingredienten.forEach { ingredient in
                                                            ingredient.isBoodschap = true
                                                        }
                                                    }
                                                    showSuccessMessage.toggle()
                                                }
                                                                                                
                                            } label: {
                                                Label("Voeg toe aan boodschappen", systemImage: "plus.square.fill")
                                            }
                                        } label: {
                                            Image(systemName: "basket.fill")
                                        }
                                        .alert(isPresented: $showSuccessMessage) {
                                            Alert(
                                                title: Text("Gelukt!"),
                                                message: Text("Boodschappen toegevoegd")
                                            
                                            )
                                        }
                                    }
                                    
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Menu {
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
                                        } label: {
                                            Label("Menu", systemImage: "ellipsis.circle")
                                        }
                                    }
                                    
                                }
                        } label: {
                            ZStack {
                                // Shadow
                                Rectangle()
                                .frame(width: 170, height: 210)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                                
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
                                    
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .searchable(text: $searchQuery, prompt: "Zoek gerecht of Ingredient")
            .navigationTitle("Receptenboekje")
            .toolbar {
                ToolbarItem {
                    Button (action: {
                        showCreate.toggle()
                    }, label: {
                        Label("Add Item", systemImage: "plus")
                    })
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

            
        }

    }
}


#Preview {
    Boekje()
}
