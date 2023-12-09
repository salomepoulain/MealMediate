//
//  test3.swift
//  project
//
//  Created by Salome Poulain on 09/12/2023.
//

import SwiftUI
import SwiftData

struct Test3: View {
    
    @Query(filter: #Predicate<ReceptItem> { recept in
           recept.weekDag != nil
       }) private var allRecepten: [ReceptItem]
    
    
    @State private var isSheetPresented = false
    
    @Bindable var user: User
    
    var body: some View {
        
        VStack {
            // display numbers row
            HStack(spacing: 0) {
                ForEach(0..<7) { dayIndex in
                    let adjustedIndex = dayIndex + user.startDay
                    VStack {
                        Text(getDayAbbreviation(for: adjustedIndex))
                            .font(.caption)
                            .padding(4)
                            .background(isCurrentDate(for: adjustedIndex) ? Color.white : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .foregroundColor(isCurrentDate(for: adjustedIndex) ? Color.accentColor : Color.primary)
                            .padding(2)

                        Text(getDayNumber(for: adjustedIndex))
                            .padding(.top, -4)
                            .padding(.bottom, 6)
                            .foregroundColor(isCurrentDate(for: adjustedIndex) ? Color.white : Color.primary)
                    }
                    .background(isCurrentDate(for: adjustedIndex) ? Color.accentColor : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.9 / 7)

                }

            }
                
            Divider()
                .padding(.bottom, 20)
            
            if !allRecepten.isEmpty {
                
                // display vandaag
                VStack {
                    HStack {
                        Text("Vandaag")
                            .foregroundColor(Color.primary)
                            .bold()
                            .padding(.bottom, 8)
                        Spacer()
                    }
                    
                    let vandaag = (((Calendar.current.component(.weekday, from: Date()) + 5) % 7) - user.startDay) % 7
                    
                    ForEach(allRecepten) { recept in
                        if let weekDag = recept.weekDag, weekDag.contains(vandaag) {
                            NavigationLink {
                                ReceptFinishedView(receptItem: recept)
                            } label: {
                                WeekGerechtView(receptItem: recept)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5)
                                    .padding(.bottom, 20)
                                    .foregroundColor(Color.primary)
                            }
                        }
                    }
                    
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
                
                // display list
                VStack() {
                    ForEach(0..<7) { dayIndex in
                        let adjustedIndex = dayIndex + user.startDay
                        let dayName = getFullDayName(for: adjustedIndex)
                        
                        VStack {
                            HStack {
                                Text(dayName)
                                    .foregroundColor(isDayPassed(for: adjustedIndex) ? Color.gray : Color.primary)
                                    .bold()
                                Spacer()
                            }
                            
                            ForEach(allRecepten) { recept in
                                if let weekDag = recept.weekDag, weekDag.contains(dayIndex) {
                                    NavigationLink {
                                        ReceptFinishedView(receptItem: recept)
                                    } label: {
                                        WeekGerechtView(receptItem: recept)
                                            .foregroundColor(Color.primary)
                                            .shadow(color: isDayPassed(for: adjustedIndex) ? Color.clear : Color.gray.opacity(0.5), radius: 5)
                                            .overlay(
                                                isDayPassed(for: adjustedIndex) ?
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .foregroundColor(Color.gray.opacity(0.3))
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    : nil
                                            )
                                            .padding(.bottom, 20)
                                    }
                                }
                            }
                            
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
                        test2(user: user)
                    }
                    
                    Spacer()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width*0.9)

        
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
        let index = index % 7
        let weekdays = ["maan", "dins", "woens", "dond", "vrij", "zat", "zon"]
        return weekdays[index]
    }
    
    func getFullDayName(for index: Int) -> String {
        let index = index % 7
        let weekdays = ["Maandag", "Dinsdag", "Woensdag", "Donderdag", "Vrijdag", "Zaterdag", "Zondag"]
        return weekdays[index]
    }
    
    func isDayPassed(for index: Int) -> Bool {
        let today = (Calendar.current.component(.weekday, from: Date()) + 5) % 7
        return index < today
    }
}


