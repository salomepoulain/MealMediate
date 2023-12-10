//
//  VoegSchemaToe.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI
import SwiftData

struct VoegSchemaToe: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Use arrays to store state and selected items
    @State private var isReceptenPickerPresented: [Bool] = Array(repeating: false, count: 7)
    @State private var selectedRecept: [ReceptItem?] = Array(repeating: nil, count: 7)
    
    @State private var numberOfOngezondeDagen: Int = 1
    
    @Query private var allRecepten: [ReceptItem]
    
    @Bindable var user: User

    
    var body: some View {
        NavigationStack {
            
            
            List {

                // Add a Picker to select starting day
                Picker("Startdag deze week", selection: $user.startDay) {
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
                
                // New Stepper for aantal ongezonde dagen
                Picker("Aantal ongezonde dagen", selection: $numberOfOngezondeDagen) {
                    ForEach(0..<3) { number in
                        Text("\(number)")
                    }
                }
                
                Section {
                    Button {
                        fillAutomatically()
                    } label: {
                        Label("Vul schema automatisch in", systemImage: "dice.fill")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)) // Pas dit aan zoals nodig
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(EmptyView())
                    .listRowInsets(EdgeInsets())
                    .shadow(color: Color.accentColor.opacity(0.5), radius: 3)
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
                            Label("Kies zelf uit recepten", systemImage: "book.pages.fill")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .sheet(isPresented: $isReceptenPickerPresented[day]) {
                            ReceptenPickerView(selectedRecept: $selectedRecept[day])
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
    
    func getRandomNumbers() -> [Int] {
        var mutableArray = Array(0..<7) // All days
        var selectedNumbers: [Int] = []
        
        for _ in 0..<numberOfOngezondeDagen {
            // Choose a random day from the array
            let randomIndex = Int.random(in: 0..<mutableArray.count)
            let selectedNumber = mutableArray.remove(at: randomIndex)
            
            // Add the selected number to the results
            selectedNumbers.append(selectedNumber)
        }
        
        return selectedNumbers
    }
    
    // Functie om automatisch recepten in te vullen
    func fillAutomatically() {
        let gezondeRecepten = allRecepten.filter { $0.isGezond }
        let ongezondeRecepten = allRecepten.filter { !$0.isGezond }

        if !gezondeRecepten.isEmpty && !ongezondeRecepten.isEmpty {
            let randomNumbers = getRandomNumbers()
            assignRecepten(randomNumbers: randomNumbers, ongezondeRecepten: ongezondeRecepten, gezondeRecepten: gezondeRecepten)
        } else {
            fillWithRandomRecepten(gezondeRecepten: gezondeRecepten)
        }
    }

    // Functie om recepten toe te wijzen op basis van willekeurige getallen
    func assignRecepten(randomNumbers: [Int], ongezondeRecepten: [ReceptItem], gezondeRecepten: [ReceptItem]) {
        for day in 0..<7 {
            if randomNumbers.contains(day) {
                assignRandomOngezondRecept(day: day, ongezondeRecepten: ongezondeRecepten)
            } else {
                assignRandomGezondRecept(day: day, gezondeRecepten: gezondeRecepten)
            }
        }
    }

    // Functie om willekeurig ongezond recept toe te wijzen aan een dag
    func assignRandomOngezondRecept(day: Int, ongezondeRecepten: [ReceptItem]) {
        if let randomOngezondRecept = ongezondeRecepten.randomElement() {
            selectedRecept[day] = randomOngezondRecept
        }
    }

    // Functie om willekeurig gezond recept toe te wijzen aan een dag
    func assignRandomGezondRecept(day: Int, gezondeRecepten: [ReceptItem]) {
        if let randomGezondRecept = gezondeRecepten.randomElement() {
            selectedRecept[day] = randomGezondRecept
        }
    }

    // Functie om automatisch in te vullen met willekeurige gezonde recepten
    func fillWithRandomRecepten(gezondeRecepten: [ReceptItem]) {
        for day in 0..<7 {
            assignRandomGezondRecept(day: day, gezondeRecepten: gezondeRecepten)
        }
    }
    
}

