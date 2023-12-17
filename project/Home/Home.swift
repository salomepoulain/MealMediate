//
//  Home.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData

struct Home: View {
    // MARK: - Properties
    
    @Environment(\.modelContext) var context
    
    // Query to fetch all recepten with a non-nil weekDag property
    @Query(filter: #Predicate<ReceptItem> { recept in
        recept.weekDag != nil
    }) private var allRecepten: [ReceptItem]
    
    // Query to fetch all users
    @Query private var users: [User]
    
    // State variable to control the success message alert
    @State private var showSuccessMessage = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                Group {
                    // Display schema views for each user
                    ForEach(users) { user in
                        if let user = users.first(where: { $0.id == 1 }) {
                            SchemaView(user: user)
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .navigationTitle(getFormattedDate())
            .toolbar {
                if !allRecepten.isEmpty {
                    Group {
                        // Toolbar item to add all recepten to boodschappen
                        ToolbarItem {
                            Menu {
                                Button {
                                    // Set isBoodschap to true for all recepten
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

                        // Toolbar item to clear the week schema
                        ToolbarItem {
                            Menu {
                                Button(role: .destructive) {
                                    // Set weekDag to nil for all recepten
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
            }
            .alert(isPresented: $showSuccessMessage) {
                Alert(
                    title: Text("Gelukt!"),
                    message: Text("Boodschappen toegevoegd")
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // Function to get the formatted date
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatter.dateFormat = "EEEE d MMM"
        return dateFormatter.string(from: Date()).uppercased()
    }
}
