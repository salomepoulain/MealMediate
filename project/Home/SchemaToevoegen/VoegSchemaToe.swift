//
//  VoegSchemaToe.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI
import SwiftData

struct VoegSchemaToe: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Use arrays to store state and selected items
    @State private var isReceptenPickerPresented: [Bool] = Array(repeating: false, count: 7)
    @State private var selectedRecept: [ReceptItem?] = Array(repeating: nil, count: 7)
    
    @State private var numberOfOngezondeDagen: Int = 1
    
    @Query private var allRecepten: [ReceptItem]
    
    @Bindable var user: User
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                // Section to select starting day and number of unhealthy days
                Section {
                    Picker("Startdag deze week", selection: $user.startDay) {
                        ForEach(0..<7) { day in
                            // Display "Vandaag" label for the current day
                            let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
                            if day == today {
                                Label("Vandaag", systemImage: "pin.fill")
                                    .tag(day)
                                    .foregroundColor(Color.accentColor)
                            } else {
                                Text(dayOfWeek(day)).tag(day)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Aantal ongezonde dagen")
                            .padding(.bottom, 5)
                        
                        Picker("", selection: $numberOfOngezondeDagen) {
                            ForEach(0...2, id: \.self) { day in
                                Text("\(day)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding([.top, .bottom], 5)
                }
                
                // Section with buttons to fill the schema automatically
                Section {
                    Button(action: fillAutomatically) {
                        Label("Vul schema automatisch in", systemImage: "dice.fill")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
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
                
                // Loop through each day of the week to fill in the GerechtView
                ForEach(0..<7) { day in
                    let adjustedIndex = (day + user.startDay) % 7
                    Section(header: Text(dayOfWeek(adjustedIndex))) {
                        if let recept = selectedRecept[day] {
                            LijstWeekGerechtView(receptItem: recept)
                        }
                        
                        // Button to present the recepten picker sheet
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
                // Toolbar items for navigation bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Sluit")
                    }

                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addReceptenToWeekSchema()
                        dismiss()
                    }) {
                        Text("Voeg toe")
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // Function to add selected recepten to the week schema
    func addReceptenToWeekSchema() {
        for day in 0..<7 {
            addWeekDayToSelectedRecept(selectedRecept: $selectedRecept[day], day: day)
        }
    }
    
    // Function to get the day of the week as a string
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
    
    // Function to get random numbers for unhealthy days
    func getRandomUnhealthyDays() -> [Int] {
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
    
    // Function to fill the schema automatically
    func fillAutomatically() {
        var gezondeRecepten = allRecepten.filter { $0.isGezond }
        var ongezondeRecepten = allRecepten.filter { !$0.isGezond }

        if !gezondeRecepten.isEmpty && !ongezondeRecepten.isEmpty {
            let unhealthyDays = getRandomUnhealthyDays()
            assignRecepten(unhealthyDays: unhealthyDays, ongezondeRecepten: &ongezondeRecepten, gezondeRecepten: &gezondeRecepten)
        } else {
            fillWithRandomRecepten(gezondeRecepten: &gezondeRecepten)
        }
    }

    // Function to assign recepten based on random numbers
    func assignRecepten(unhealthyDays: [Int], ongezondeRecepten: inout [ReceptItem], gezondeRecepten: inout [ReceptItem]) {
        for day in 0..<7 {
            if unhealthyDays.contains(day) {
                assignRandomOngezondRecept(day: day, ongezondeRecepten: &ongezondeRecepten)
            } else {
                assignRandomGezondRecept(day: day, gezondeRecepten: &gezondeRecepten)
            }
        }
    }

    // Function to assign a random unhealthy recept to a day
    func assignRandomOngezondRecept(day: Int, ongezondeRecepten: inout [ReceptItem]) {
        guard let index = ongezondeRecepten.indices.randomElement() else {
            return // Return if the array is empty
        }
        
        let randomOngezondRecept = ongezondeRecepten.remove(at: index)
        selectedRecept[day] = randomOngezondRecept
    }

    // Function to assign a random healthy recept to a day
    func assignRandomGezondRecept(day: Int, gezondeRecepten: inout [ReceptItem]) {
        guard let index = gezondeRecepten.indices.randomElement() else {
            return // Return if the array is empty
        }
        
        let randomGezondRecept = gezondeRecepten.remove(at: index)
        selectedRecept[day] = randomGezondRecept
    }

    // Function to fill the schema with random healthy recepten
    func fillWithRandomRecepten(gezondeRecepten: inout [ReceptItem]) {
        for day in 0..<7 {
            assignRandomGezondRecept(day: day, gezondeRecepten: &gezondeRecepten)
        }
    }
    
    // Function to add a weekday to the selected recept
    func addWeekDayToSelectedRecept(selectedRecept: Binding<ReceptItem?>, day: Int) {
        if let recept = selectedRecept.wrappedValue {
            if recept.weekDag == nil {
                recept.weekDag = [day]
            } else {
                recept.weekDag?.append(day)
            }
        }
    }
}

