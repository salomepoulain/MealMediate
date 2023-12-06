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
    
    @State private var isReceptenPickerPresented0 = false
    @State private var isReceptenPickerPresented1 = false
    @State private var isReceptenPickerPresented2 = false
    @State private var isReceptenPickerPresented3 = false
    @State private var isReceptenPickerPresented4 = false
    @State private var isReceptenPickerPresented5 = false
    @State private var isReceptenPickerPresented6 = false
    
    @State private var selected0: ReceptItem? = nil
    @State private var selected1: ReceptItem? = nil
    @State private var selected2: ReceptItem? = nil
    @State private var selected3: ReceptItem? = nil
    @State private var selected4: ReceptItem? = nil
    @State private var selected5: ReceptItem? = nil
    @State private var selected6: ReceptItem? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Maandag")) {
                    
                    if let recept0 = selected0 {
                        LijstWeekGerechtView(receptItem: recept0)
                    }
                    
                    Button {
                        isReceptenPickerPresented0.toggle()
                        
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented0) {
                        ReceptenPickerView(selectedRecept: $selected0)
                    }
                }
                
                Section(header: Text("Dinsdag")) {
                    if let recept1 = selected1 {
                        LijstWeekGerechtView(receptItem: recept1)
                    }
                    
                    Button {
                        isReceptenPickerPresented1.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented1) {
                        ReceptenPickerView(selectedRecept: $selected1)
                    }
                }
                
                Section(header: Text("Woensdag")) {
                    if let recept2 = selected2 {
                        LijstWeekGerechtView(receptItem: recept2)
                    }
                    
                    Button {
                        isReceptenPickerPresented2.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented2) {
                        ReceptenPickerView(selectedRecept: $selected2)
                    }
                }
                
                Section(header: Text("Donderdag")) {
                    if let recept3 = selected3 {
                        LijstWeekGerechtView(receptItem: recept3)
                    }
                    
                    Button {
                        isReceptenPickerPresented3.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented3) {
                        ReceptenPickerView(selectedRecept: $selected3)
                    }
                    
                }
                
                Section(header: Text("Vrijdag")) {
                    if let recept4 = selected4 {
                        LijstWeekGerechtView(receptItem: recept4)
                    }
                    
                    Button {
                        isReceptenPickerPresented4.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented4) {
                        ReceptenPickerView(selectedRecept: $selected4)
                    }
                    
                }
                
                Section(header: Text("Zaterdag")) {
                    if let recept5 = selected5 {
                        LijstWeekGerechtView(receptItem: recept5)
                    }
                    
                    Button {
                        isReceptenPickerPresented5.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented5) {
                        ReceptenPickerView(selectedRecept: $selected5)
                    }
                }
                
                Section(header: Text("Zondag")) {
                    if let recept6 = selected6 {
                        LijstWeekGerechtView(receptItem: recept6)
                    }
                    
                    Button {
                        isReceptenPickerPresented6.toggle()
                    } label: {
                        Label("Kies uit recepten", systemImage: "book.pages.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .sheet(isPresented: $isReceptenPickerPresented6) {
                        ReceptenPickerView(selectedRecept: $selected6)
                    }
                    
                }
            }
    
            .navigationTitle("Voeg recepten toe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        dismiss()
                    }, label: {
                        Text("Sluit")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        addWeekDayToSelectedRecept(selectedRecept: $selected0, day: 0)
                        addWeekDayToSelectedRecept(selectedRecept: $selected1, day: 1)
                        addWeekDayToSelectedRecept(selectedRecept: $selected2, day: 2)
                        addWeekDayToSelectedRecept(selectedRecept: $selected3, day: 3)
                        addWeekDayToSelectedRecept(selectedRecept: $selected4, day: 4)
                        addWeekDayToSelectedRecept(selectedRecept: $selected5, day: 5)
                        addWeekDayToSelectedRecept(selectedRecept: $selected6, day: 6)
                        
                        dismiss()
                    }, label: {
                        // recept.weekDag = dat getal
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
}

#Preview {
    VoegSchemaToe()
}
