//
//  SchemaView.swift
//  project
//
//  Created by Salome Poulain on 10/12/2023.
//

import SwiftUI
import SwiftData

struct SchemaView: View {
    // MARK: - Properties
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query(filter: #Predicate<ReceptItem> { recept in
        recept.weekDag != nil
    }) private var allRecepten: [ReceptItem]
    
    @State private var showSuccessMessage = false
    @State private var isSheetPresented = false
    @State private var isAddSheetPresented = false
    @State private var capturedDayIndex: Int = 0
    
    @Bindable var user: User
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Display the numbers row
            DayNumbersRow(startDay: user.startDay)
            
            Divider().padding(.bottom, 20)
            
            if !allRecepten.isEmpty {
                // Display "Vandaag"
                VandaagView(allRecepten: allRecepten, user: user)
                
                Divider().padding(.bottom, 20)
                
                // Display the list
                WeekList(allRecepten: allRecepten, user: user, isAddSheetPresented: $isAddSheetPresented, capturedDayIndex: $capturedDayIndex)
            } else {
                // Display "Genereer weekschema" button
                GenerateSchemaButton(isSheetPresented: $isSheetPresented, user: user)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}
// MARK: - Helper Functions

// Helper functions extension
extension View {
    func removeDayIndexFromRecept(_ recept: ReceptItem, dayIndex: Int) {
        if let weekDag = recept.weekDag, weekDag.count == 1 && weekDag.contains(dayIndex) {
            recept.weekDag = nil
        } else if let weekDag = recept.weekDag, let indexToRemove = weekDag.firstIndex(of: dayIndex) {
            recept.weekDag?.remove(at: indexToRemove)
        }
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

// MARK: - Subviews

struct DayNumbersRow: View {
    let startDay: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { dayIndex in
                DayNumberView(dayIndex: dayIndex, startDay: startDay)
            }
        }
    }
}

struct DayNumberView: View {
    let dayIndex: Int
    let startDay: Int

    var body: some View {
        let adjustedIndex = dayIndex + startDay

        VStack {
            Text(getDayAbbreviation(for: adjustedIndex))
                .font(screenSize() == .smallerThaniPhone11 ? .system(size: 10) : .system(size: 12))
                .padding(4)
                .background(isCurrentDate(for: adjustedIndex) ? Color("Tile") : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundColor(isCurrentDate(for: adjustedIndex) ? Color.accentColor : Color.primary)
                .padding(2)

            Text(getDayNumber(for: adjustedIndex))
                .padding(.top, -4)
                .padding(.bottom, 6)
                .foregroundColor(isCurrentDate(for: adjustedIndex) ? Color("Tile") : Color.primary)
        }
        .background(isCurrentDate(for: adjustedIndex) ? Color.accentColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .bold()
        .frame(width: UIScreen.main.bounds.width * 0.9 / 7)
    }

    func screenSize() -> ScreenSize {
        let screenWidth = UIScreen.main.bounds.width

        if screenWidth <= 375 { // iPhone se width
            return .smallerThaniPhone11
        } else {
            return .largerThanOrEqualToiPhone11
        }
    }

    enum ScreenSize {
        case smallerThaniPhone11
        case largerThanOrEqualToiPhone11
    }
}



struct VandaagView: View {
    let allRecepten: [ReceptItem]
    let user: User
    
    var body: some View {
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
                            .shadow(color: Color("Shadow").opacity(0.4), radius: 8)
                            .padding(.bottom, 20)
                            .foregroundColor(Color.primary)
                    }
                }
            }
            
            if allRecepten.allSatisfy({ recept in
                recept.weekDag == nil || !recept.weekDag!.contains(vandaag)
            }) {
                Text("Geen gerecht voor vandaag geselecteerd")
                    .foregroundColor(Color.gray)
                    .italic()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct WeekList: View {
    let allRecepten: [ReceptItem]
    let user: User
    @Binding var isAddSheetPresented: Bool
    @Binding var capturedDayIndex: Int
    
    var body: some View {
        VStack {
            ForEach(0..<7) { dayIndex in
                let adjustedIndex = dayIndex + user.startDay
                DayReceptList(dayIndex: dayIndex, adjustedIndex: adjustedIndex, allRecepten: allRecepten, isAddSheetPresented: $isAddSheetPresented, capturedDayIndex: $capturedDayIndex)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct DayReceptList: View {
    let dayIndex: Int
    let adjustedIndex: Int
    let allRecepten: [ReceptItem]
    @Binding var isAddSheetPresented: Bool
    @Binding var capturedDayIndex: Int
    
    var body: some View {
        let dayName = getFullDayName(for: adjustedIndex)
        
        VStack {
            HStack {
                Text(dayName)
                    .foregroundColor(isDayPassed(for: adjustedIndex) ? Color.gray : Color.primary)
                    .bold()
                Spacer()
            }
            
            ForEach(allRecepten.filter { recept in
                let weekDag = recept.weekDag ?? []
                return weekDag.contains(dayIndex)
            }) { recept in
                NavigationLink {
                    ReceptFinishedView(receptItem: recept)
                } label: {
                    WeekGerechtView(receptItem: recept)
                        .foregroundColor(Color.primary)
                        .overlay(
                            isDayPassed(for: adjustedIndex) ?
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(Color("Cover").opacity(0.6))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                : nil
                        )
                        .padding(.bottom, 20)
                        .contextMenu {
                            Button(role: .destructive) {
                                removeDayIndexFromRecept(recept, dayIndex: dayIndex)
                            } label : {
                                Label("\(dayName) verwijderen", systemImage: "trash.fill")
                            }
                        }
                        .shadow(color: isDayPassed(for: adjustedIndex) ? Color.clear : Color("Shadow").opacity(0.3), radius: 8)
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Display "none" if no recipes for the current day
            if allRecepten.allSatisfy({ recept in
                recept.weekDag == nil || !recept.weekDag!.contains(dayIndex)
            }) {
                Button {
                    capturedDayIndex = dayIndex
                    isAddSheetPresented.toggle()
                } label: {
                    Image(systemName: "plus.app.fill")
                        .font(.system(size: 23))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.5), radius: 3)
                }
                .sheet(isPresented: $isAddSheetPresented) {
                    DayReceptPickerView(day: $capturedDayIndex)
                }
            }
            
        }
    }
}

struct GenerateSchemaButton: View {
    @Binding var isSheetPresented: Bool
    let user: User
    
    var body: some View {
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
                VoegSchemaToe(user: user)
            }
            
            Spacer()
        }
        .padding(.top, 70)
    }
}
