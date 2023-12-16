//
//  Home.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    @Query(filter: #Predicate<ReceptItem> { recept in
           recept.weekDag != nil
       }) private var allRecepten: [ReceptItem]
    
    @Environment(\.modelContext) var context
    
    @Query private var users: [User]
    @State private var showSuccessMessage = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                ForEach(users) { user in
                    if let user = users.first(where: { $0.id == 1 }) {
                        SchemaView(user: user)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.9)
            .navigationTitle(getFormattedDate())
            .toolbar {
                if !allRecepten.isEmpty {
                    ToolbarItem {
                        Menu {
                            Button {
                                allRecepten.forEach { recept in
                                    recept.isBoodschap = true
                                }
                                showSuccessMessage.toggle()
                            } label: {
                                Label("Voeg weekschema toe aan boodschappen", systemImage: "plus.square.fill")
                            }
                            .disabled(allRecepten.allSatisfy { $0.isBoodschap })
                        } label: {
                            Label("Voeg toe aan boodschappen", systemImage: allRecepten.allSatisfy { $0.isBoodschap } ? "basket.fill" : "basket")
                        }
                    }

                    ToolbarItem {
                        Menu {
                            Button(role: .destructive) {
                                allRecepten.forEach { recept in
                                    recept.weekDag = nil
                                }
                            } label: {
                                Label("Leeg schema", systemImage: "trash.fill")
                            }
                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert(isPresented: $showSuccessMessage) {
                Alert(
                    title: Text("Gelukt!"),
                    message: Text("Boodschappen toegevoegd")
                )
            }
            
        }
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatter.dateFormat = "EEEE d MMM"
        return dateFormatter.string(from: Date()).uppercased()
    }
}



