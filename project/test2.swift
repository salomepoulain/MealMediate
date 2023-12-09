//
//  VoegSchemaToe.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI
import SwiftData

struct test2: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Use arrays to store state and selected items
    @State private var isReceptenPickerPresented: [Bool] = Array(repeating: false, count: 7)
    @State private var selectedRecept: [ReceptItem?] = Array(repeating: nil, count: 7)
    
    @Bindable var user: User

    
    var body: some View {
        NavigationStack {
            
            List {
                // Add a Picker to select starting day
                Picker("Startdag deze week?", selection: $user.startDay) {
                    ForEach(0..<7) { day in
                        let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
                        if day == today {
                            Label(
                                title: {
                                    Text("Vandaag")
                                },
                                icon: {
                                    Image(systemName: "pin.fill")
                                }
                            )
                            .tag(day)
                                .foregroundColor(Color.accentColor)
                        } else {
                            Text(dayOfWeek(day)).tag(day)
                        }
                        
                    }
                }
                
                ForEach(0..<7) { day in
                    let adjustedIndex = (day + user.startDay) % 7
                    Section(header: Text(dayOfWeek(adjustedIndex))) {
                        if let recept = selectedRecept[day] {
                            LijstWeekGerechtView(receptItem: recept)
                        }
                        
                        Button {
                            isReceptenPickerPresented[day].toggle()
                        } label: {
                            Label("Kies uit recepten", systemImage: "book.pages.fill")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .sheet(isPresented: $isReceptenPickerPresented[day]) {
                            ReceptenPickerView(selectedRecept: $selectedRecept[day])
                        }
                    }
                }
            }
            .navigationTitle("Voeg recepten toe")
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
                        for day in 0..<7 {
                            addWeekDayToSelectedRecept(selectedRecept: $selectedRecept[day], day: day)
                        }
                        dismiss()
                    }, label: {
                        Text("Voeg toe")
                    })
                }
            }
        }
    }
    
    func addWeekDayToSelectedRecept(selectedRecept: Binding<ReceptItem?>, day: Int) {
        if let recept = selectedRecept.wrappedValue {
            if recept.weekDag == nil {
                recept.weekDag = [day]
            } else {
                recept.weekDag?.append(day)
            }
        }
    }
    
    func dayOfWeek(_ day: Int) -> String {
        switch day {
        case 0: return "Maandag"
        case 1: return "Dinsdag"
        case 2: return "Woensdag"
        case 3: return "Donderdag"
        case 4: return "Vrijdag"
        case 5: return "Zaterdag"
        case 6: return "Zondag"
        default: return ""
        }
    }
}
