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
    @Query private var items: [ReceptItem]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var isContextMenuVisible = false
    
    var body: some View {
        
        NavigationStack {
        
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    
                    ForEach(items) { item in
                        NavigationLink {
                            // TODO
                        } label: {
                            ZStack {
                                
                                // Shadow
                                Rectangle()
                                .frame(width: 170, height: 210)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(radius: 5)
                                
                                // tile
                                TileView(tile_naam: item.naam, tile_gezond: item.isGezond, tile_lekker: item.lekker, tile_vega: item.isVega, tile_tijd: item.tijd)
                                    .contextMenu {
                                        Button(action: {
                                            // TODO
                                            print("Other menu item")
                                        }) {
                                            Label("Wijzig", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) {
                                            withAnimation {
                                                context.delete(item)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.fill")
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
            .sheet(isPresented: $showCreate,
                   content: {
                NavigationStack {
                        CreateRecept()
                }
            })
            
        }
    }
}


#Preview {
    Boekje()
}
