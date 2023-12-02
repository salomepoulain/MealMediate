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
    @Query (
        sort: \ReceptItem.naam
    ) private var receptItems: [ReceptItem]
    
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var isContextMenuVisible = false
    
    var body: some View {
        
        NavigationStack {
        
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    
                    ForEach(receptItems) { item in
                        NavigationLink {
                            ReceptFinishedView(receptItem: item)
                                .toolbar {
                                    ToolbarItem {
                                        Menu {
                                            Button{
                                                ReceptEdit = item
                                            } label: {
                                                Label("Wijzig", systemImage: "pencil")
                                            }
                                            
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    context.delete(item)
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
                                
                                TileView(receptItem: item)
                                    .contextMenu {
                                        Button{
                                            ReceptEdit = item
                                        } label: {
                                            Label("Wijzig", systemImage: "pencil")
                                        }
                                               
                                        Button(role: .destructive) {
                                            withAnimation {
                                                context.delete(item)
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
