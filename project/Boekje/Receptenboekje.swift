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
    @State private var isMenuVisible = false
    @Query private var items: [ReceptItem]
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(items) { item in
                    // recept tile
                    VStack(alignment: .leading) {
                        
                        HStack {
                            // naam gerecht
                            Text(item.naam)
                                .bold()
                            
                            Spacer()
                            
                            // verwijder knop
                            Button {
                                isMenuVisible = true
                            } label: {
                                Image(systemName: "ellipsis")
                                    .contextMenu {
                                        Button(action: {
                                            // Handle other menu item
                                            print("Other menu item")
                                        }) {
                                            Label("Other Item", systemImage: "doc")
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
                        
                        
                        // onderkant informatie
                        HStack {
                            if item.isGezond {
                                HStack {
                                    Image(systemName: "carrot.fill")
                                    Text("Gezond")
                                }
                            } else {
                                HStack {
                                    Image(systemName: "carrot")
                                    Text("Ongezond")
                                }
                            }
                            
                            if item.isMakkelijk {
                                HStack {
                                    Image(systemName: "figure.walk")
                                    Text("Makkelijk")
                                }
                            } else {
                                HStack {
                                    Image(systemName: "figure.gymnastics")
                                    Text("Moeilijk")
                                }
                            }
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("\(item.tijd) min")
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listRowBackground(
                Rectangle()
                     .fill(Color(.white).opacity(0.35))
                     .cornerRadius(10.0)
                     .padding(4))
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
