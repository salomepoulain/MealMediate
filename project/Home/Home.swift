//
//  Home.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI
import SwiftData


struct HomeView: View {
    
    @Environment(\.modelContext) var context
    
    @Query private var allRecepten: [ReceptItem]
    
    @State private var weekIsLeeg = true
    
    @State private var isSheetPresented = false

    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                let filteredRecepten = allRecepten.filter { $0.weekDag != nil }
                
                
                // Weekday + numbers
                HStack(spacing: 0) {
                    ForEach(0..<7) { dayIndex in
                        VStack {
                            Text(getDayAbbreviation(for: dayIndex))
                                .font(.caption)
                                .padding(4)
                                .background(isCurrentDate(for: dayIndex) ? Color.white : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(isCurrentDate(for: dayIndex) ? Color.accentColor : Color.primary)
                                .padding(2)
                            Text(getDayNumber(for: dayIndex))
                                .padding(.top, -4)
                                .padding(.bottom, 6)
                                .foregroundColor(isCurrentDate(for: dayIndex) ? Color.white : Color.primary)
                        }
                        .background(isCurrentDate(for: dayIndex) ? Color.accentColor : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width*0.9 / 7)
                    }
                }
                
                Divider()
                    .padding(.bottom, 20)

                if !filteredRecepten.isEmpty {
                    
                    // Gerecht van vandaag
                    VStack {
                        HStack {
                            Text("Vandaag")
                                .foregroundColor(Color.primary)
                                .bold()
                                .padding(.bottom, 8)
                            
                            Spacer()
                        }
                        
                        let vandaag = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
                        
                        ForEach(allRecepten) { recept in
                            if let weekDag = recept.weekDag, weekDag.contains(vandaag) {
                                NavigationLink {
                                    ReceptFinishedView(receptItem: recept)
                                } label: {
                                    WeekGerechtView(receptItem: recept)
                                        .foregroundColor(Color.primary)
                                        .padding(.bottom, 20)
                                }
                                
                            }
                        }
                        
                        // Display "none" if no recipes for the current day
                        if allRecepten.allSatisfy({ recept in
                            recept.weekDag == nil || !recept.weekDag!.contains(vandaag)
                        }) {
                            Text("None")
                                .foregroundColor(Color.gray)
                                .italic()
                                .padding(.bottom, 20)
                        }
                    }
                    
                    Divider()
                        .padding(.bottom, 20)
                    
                    // Weekschema
                    VStack() {
                        ForEach(0..<7) { dayIndex in
                            let dayName = getFullDayName(for: dayIndex)
                            
                            VStack {
                                HStack {
                                    Text(dayName)
                                        .foregroundColor(isDayPassed(for: dayIndex) ? Color.gray : Color.primary)
                                        .bold()
                                    Spacer()
                                }
                                
                                // Check if the index matches
                                ForEach(allRecepten) { recept in
                                    if let weekDag = recept.weekDag, weekDag.contains(dayIndex) {
                                        NavigationLink {
                                            ReceptFinishedView(receptItem: recept)
                                        } label: {
                                            WeekGerechtView(receptItem: recept)
                                                .foregroundColor(Color.primary)
                                                .overlay(
                                                    isDayPassed(for: dayIndex) ?
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .foregroundColor(Color.gray.opacity(0.3))
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        : nil
                                                )
                                                .padding(.bottom, 20)
                                        }
                                    }
                                }
                                
                                // Display "none" if no recipes for the current day
                                if allRecepten.allSatisfy({ recept in
                                    recept.weekDag == nil || !recept.weekDag!.contains(dayIndex)
                                }) {
                                    Text("None")
                                        .foregroundColor(Color.gray)
                                        .italic()
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width*0.9)
                    
                } else {
                    HStack {
                        Spacer()
                                    
                        Button(action: {
                            isSheetPresented.toggle()
                        }) {
                            Label("Genereer weekschema", systemImage: "calendar.badge.plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                                .bold()
                                .shadow(color: Color.accentColor.opacity(0.5), radius: 3)
                        }
                        .sheet(isPresented: $isSheetPresented) {
                            VoegSchemaToe()
                        }
                        
                        Spacer()
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
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nl_NL")
        dateFormatter.dateFormat = "EEEE d MMM"
        return dateFormatter.string(from: Date()).uppercased()
    }
    
    func getDayNumber(for index: Int) -> String {
        let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
        let daysToAdd = index - today
        let adjustedDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date()) ?? Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        return dayFormatter.string(from: adjustedDate)
    }
    
    func isCurrentDate(for index: Int) -> Bool {
        let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
        return index == today
    }
    
    func getDayAbbreviation(for index: Int) -> String {
        let weekdays = ["maan", "dins", "woens", "dond", "vrij", "zat", "zon"]
        return weekdays[index]
    }
    
    func getFullDayName(for index: Int) -> String {
            let weekdays = ["Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag", "Zondag"]
            return weekdays[index]
        }
    
    func isDayPassed(for index: Int) -> Bool {
        let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
        return index < today
    }
}


