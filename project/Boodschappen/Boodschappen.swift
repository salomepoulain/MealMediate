//
//  Boodschappen.swift
//  project
//
//  Created by Salome Poulain on 05/12/2023.
//

import SwiftUI
import SwiftData

struct Boodschappen: View {
    
    @Environment(\.modelContext) private var context
    @Query(sort: \IngredientItem.naam, order: .forward
           ) var allIngredienten: [IngredientItem]
        
    var body: some View {
           NavigationStack {
               List {
                   ForEach(allIngredienten) { ingredient in
                       if let recepten = ingredient.recepten, recepten.count > 0 {
                           let filteredRecepten = recepten.filter { $0.isBoodschap }
                           
                           // Show DisclosureGroup only if filteredRecepten is not empty
                           if !filteredRecepten.isEmpty {
                               DisclosureGroup {
                                   ForEach(filteredRecepten) { recept in
                                       NavigationLink {
                                           ReceptFinishedView(receptItem: recept)
                                       } label: {
                                           HStack {
                                               Spacer()
                                               ReceptNavigationlinkView(recept: recept)
                                           }
                                       }
                                       .deleteDisabled(true)
                                   }
                               } label: {
                                   Button {
                                       ingredient.isKlaar.toggle()
                                   } label: {
                                       HStack(spacing: 10) {
                                           Image(systemName: ingredient.isKlaar ? "largecircle.fill.circle" : "circle")
                                               .foregroundColor(Color.accentColor)
                                               .padding(.trailing, 3)

                                           Text("(\(filteredRecepten.count))  \(ingredient.naam)")
                                               .padding([.leading, .trailing], 2)
                                               .foregroundColor(ingredient.isKlaar ? .gray : .primary)
                                               .overlay(
                                                   ingredient.isKlaar ?
                                                       Rectangle()
                                                           .frame(height: 2)
                                                           .offset(y: 2)
                                                           .foregroundColor(.gray) :
                                                       nil
                                               )
                                       }
                                       .contentShape(Rectangle())
                                   }
                                   .buttonStyle(PlainButtonStyle())
                               }
                               .listStyle(PlainListStyle())
                           }
                       }
                   }
                   
               }
               .toolbar {
                   Menu {
                       
                       Button(role: .destructive) {
                           allIngredienten.forEach { ingredient in
                               
                               ingredient.isKlaar = false
                               
                               ingredient.recepten?.forEach { recept in
                                   recept.isBoodschap = false
                               }
                           }
                           
                       } label: {
                           Label("Verwijder alles", systemImage: "trash.fill")
                       }
                   } label: {
                       Label("Menu", systemImage: "ellipsis.circle")
                   }
               }
               .navigationTitle("Boodschappen")
           }
    }
}

