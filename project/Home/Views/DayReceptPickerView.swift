//
//  DayReceptPickerView.swift
//  project
//
//  Created by Salome Poulain on 10/12/2023.
//

import SwiftUI
import SwiftData

struct DayReceptPickerView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query private var recepten: [ReceptItem]
    @Query(sort: \IngredientItem.naam, order: .forward) var allIngredienten: [IngredientItem]

    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 165))
    ]
    
    @State private var searchQuery = ""
    @State private var selectedRecept: ReceptItem?

    @Binding var day: Int
    
    var filteredRecepten: [ReceptItem] {
        
        if searchQuery.isEmpty{
            return recepten
        }
        
        let filteredRecepten = recepten.compactMap { item in
            let naamContainsQuery = item.naam.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            return naamContainsQuery ? item : nil
        }
        
        return filteredRecepten
    }

    
    var body: some View {
        
        
        NavigationStack {
        
            ScrollView {
                
                Button {
                    if let randomRecept = filteredRecepten.randomElement() {
                        selectedRecept = randomRecept
                    }
                } label: {
                    Label("Selecteer willekeurig", systemImage: "dice.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .bold()
                        .shadow(color: Color.accentColor.opacity(0.5), radius: 3)
                }
                .padding([.bottom, .top], 20)
                

                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    
                    ForEach(filteredRecepten) { recept in
                        TilePickerView(receptItem: recept)
                            .onTapGesture {
                                selectedRecept = recept
                            }
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedRecept == recept ? Color.accentColor : Color.clear, lineWidth: 3)
                                    .background(selectedRecept == recept ? Color.accentColor.opacity(0.05) : Color.clear)
                                    .shadow(color: selectedRecept == recept ? Color.accentColor.opacity(0.5) : Color.clear, radius: 3)
                            )
                            
                    }
                }
                .padding()
            }
            .searchable(text: $searchQuery, prompt: "Zoek recept")
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(selectedRecept != nil ? "\(selectedRecept!.naam)" : "Selecteer een gerecht")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addWeekDayToSelectedRecept(selectedRecept: $selectedRecept, day: day)
                        dismiss()
                    }, label: {
                        Text("Voeg toe")
                    })
                }
            }
        }

    }
    
    func addWeekDayToSelectedRecept(selectedRecept: Binding<ReceptItem?>, day: Int) {
        print("addWeekDayToSelectedRecept called for day \(day)")

        if let recept = selectedRecept.wrappedValue {
            if recept.weekDag == nil {
                recept.weekDag = [day]
            } else {
                recept.weekDag?.append(day)
            }
            
            print("Recipe \(recept.naam) updated with weekDag: \(recept.weekDag ?? []) for day \(day).")
        }
        

    }
}
