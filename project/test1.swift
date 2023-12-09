//
//  test1.swift
//  project
//
//  Created by Salome Poulain on 07/12/2023.
//

import SwiftUI
import SwiftData

struct test1: View {
    
    @Query(filter: #Predicate<ReceptItem> { recept in
           recept.weekDag != nil
       }) private var allRecepten: [ReceptItem]
    
    @Environment(\.modelContext) var context
    
    @Query private var users: [User]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                ForEach(users) { user in
                    if let user = users.first(where: { $0.id == 1 }) {
                        Test3(user: user)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.9)
            .navigationTitle(getFormattedDate())
            .toolbar {
                Menu {
                    Button(role: .destructive) {
                        allRecepten.forEach { recept in
                            recept.weekDag = nil
                        }
                    } label: {
                        Label("leeg schema", systemImage: "trash.fill")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
            
        }
    }
    
    func handleNewUser() {
        let newUser = User(id: 1, startDay: 0)
        context.insert(newUser)
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatter.dateFormat = "EEEE d MMM"
        return dateFormatter.string(from: Date()).uppercased()
    }
    
    

}
