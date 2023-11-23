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
                        ZStack {
                            
                            // tile
                            Rectangle()
                                .frame(width: 165, height: 210)
                                .foregroundColor(appYellow)
                                // geef menu om te wijzigen of verwijderen
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
                                        Label("Verwijder", systemImage: "trash.fill")
                                    }
                                }
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                                                                    
                            
                            // recept tile
                            VStack(alignment: .leading) {
                                
                                Rectangle()
                                    .frame(width: 170, height: 130)
                                    .foregroundColor(Color.green)
                                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                                
                                Spacer()
                                
                                Text(item.naam)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .font(.system(size: 14))
                                    .bold()
                                
                                Spacer()
                                
                                // onderkant informatie
                                HStack {
                                    if item.isGezond {
                                        HStack {
                                            Image(systemName: "carrot.fill")
                                                .foregroundColor(.green)
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "carrot")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    if item.isMakkelijk {
                                        HStack {
                                            Image(systemName: "figure.walk")
                                                .foregroundColor(.green)
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "figure.gymnastics")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Text("\(item.tijd) min")
                                            .font(.system(size: 14))
                                            .lineLimit(1)
                                    }
                                }
                            }
                            .padding()
                        }
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    Boekje()
}
