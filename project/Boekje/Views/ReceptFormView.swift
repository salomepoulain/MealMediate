//
//  ReceptFormView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI

struct ReceptListView: View {
    @Bindable var item: ReceptItem
    @State private var isPickerPresented = false

    var body: some View {
        List {
            Section(header: Text("Geef naam")) {
                TextField("Naam", text: $item.naam)
            }

            Section(header: Text("Eigenschappen")) {
                Toggle("Gezond", isOn: $item.isGezond)
                Toggle("Vegetarisch", isOn: $item.isVega)

                VStack {
                    HStack {
                        Text("Tijd in minuten")

                        Spacer()

                        Button(action: {
                            isPickerPresented.toggle()
                        }, label: {
                            Text("\(item.tijd * 5)")
                        })
                    }

                    if isPickerPresented {
                        Picker("Select Time", selection: $item.tijd) {
                            ForEach(0..<20) { index in
                                Text("\(index * 5)")
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(WheelPickerStyle())
                    }
                }
            }

            Section(header: Text("Beoordeling")) {
                Picker(selection: $item.lekker, label: Text("")) {
                    Image("bad").tag(1)
                    Image("mid").tag(2)
                    Image("good").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.top, .bottom], 7)
            }

            Section(header: Text("Kies ingredienten")) {
                TextField("Ingredient", text: $item.ingredienten)
            }

            Section(header: Text("Voeg stappen toe")) {
                TextField("Stap 1", text: $item.uitleg)
            }
        }
    }
}
