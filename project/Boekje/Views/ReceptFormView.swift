//
//  ReceptFormView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ReceptListView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var item: ReceptItem
    
    @Query(sort: \IngredientItem.naam, order: .forward) var ingredienten: [IngredientItem]
    
    @State private var isPickerPresented = false
    @State private var isIngredientListViewPresented = false
    
    private var shouldShowIngredients: Bool {
            ingredienten.contains { $0.isChecked }
        }
    
    var isNameEntered: Binding<Bool>?
    var isImageAdded: Binding<Bool>?
    
    @State var SelectedPhoto: PhotosPickerItem?

    var body: some View {
        List {
            
            // Naam
            Section {
                TextField("Naam recept", text: $item.naam, axis: .vertical)
                    .onChange(of: item.naam) {
                        if !item.naam.isEmpty {
                            isNameEntered?.wrappedValue = true
                        } else {
                            isNameEntered?.wrappedValue = false
                        }
                    }
            }
            
            // Photo
            Section {
                PhotosPicker(selection: $SelectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {

                    if item.image == nil {
                        Label("Voeg foto toe", systemImage: "photo.badge.plus.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    if let imageData = item.image,
                       let uiImage = UIImage(data: imageData) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width-30, height: 270)
                                .clipped()
                                .padding([.top, .bottom], -15)

                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding(20)
                        }
                    }
                }
                .onChange(of: item.image) {
                    if item.image != nil{
                        isImageAdded?.wrappedValue = true
                    } else {
                        isImageAdded?.wrappedValue = true
                    }
                }
            }

            // Opties
            Section {
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
                
                VStack(alignment: .leading) {
                    Text("Hoe lekker")
                    
                    Picker(selection: $item.lekker, label: Text("")) {
                        Image("bad").tag(1)
                        Image("mid").tag(2)
                        Image("good").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.top, .bottom], 7)
                }
                
            }
            
            
            // Ingredienten
            Section {
                
                Stepper("Porties: \(item.porties)", value: $item.porties, in: 1...8)
                
                if shouldShowIngredients {
                    VStack(alignment: .leading) {
                        ForEach(ingredienten) { ingredient in
                            if ingredient.isChecked {
                                Text("- \(ingredient.naam)")
                                    .padding(.bottom, 1)
                            }
                        }
                    }
                }
                
                Button {
                    isIngredientListViewPresented.toggle()
                } label: {
                    Label("Selecteer ingrediëntenen", systemImage: "list.bullet.clipboard.fill")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .sheet(isPresented: $isIngredientListViewPresented) {
                    IngredientListView(receptItem: item)
                }
                

            }
            
            
            // Text uitleg
            Section {
                ForEach(item.uitleg.indices, id: \.self) { index in
                    TextField("Uitleg stap \(index + 1)", text: $item.uitleg[index], axis: .vertical)
                        .lineLimit(2...4)
                }
                .onDelete { indexSet in
                    item.uitleg.remove(atOffsets: indexSet)
                }
                
                Button {
                    if item.uitleg.allSatisfy({ !$0.isEmpty }) {
                        item.uitleg.append("")
                    }
                } label: {
                    Label("Voeg stap toe", systemImage: "text.badge.plus")
                        .foregroundColor(item.uitleg.allSatisfy { !$0.isEmpty } ? Color.accentColor : Color.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

            }

        }
        .task(id: SelectedPhoto){
            if let data = try? await SelectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
            }
               
        }
    }
    
}
