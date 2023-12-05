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
    @Query(filter: #Predicate { $0.isBoodschap},
           sort: \IngredientItem.naam, order: .forward
           ) var allIngredienten: [IngredientItem]
        
    var body: some View {
        NavigationStack {
            List {
                
                ForEach(allIngredienten) { ingredient in
                    if let recepten = ingredient.recepten, recepten.count > 0 {
                        DisclosureGroup {
                            ForEach(recepten) { recept in
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

                                    Text("(\(recepten.count))  \(ingredient.naam)")
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
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        allIngredienten[index].isBoodschap = false
                        allIngredienten[index].isKlaar = false
                    }
                }
                
            }
            
            .navigationTitle("Boodschappen")
        }
    }
}
