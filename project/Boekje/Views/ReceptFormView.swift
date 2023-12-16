//
//  ReceptFormView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ReceptFormView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @Bindable var item: ReceptItem
    @State private var originalItem: ReceptItem?
    
    @Query(sort: \IngredientItem.naam, order: .forward) var ingredienten: [IngredientItem]
    
    @State private var selectedIngredienten: [IngredientItem]?
    
    @State private var isPickerPresented = false
    @State private var isIngredientListViewPresented = false
    @State var SelectedPhoto: PhotosPickerItem?
    
    @Binding var title: String

    var body: some View {
        NavigationStack {
            List {
                
                // Naam
                Section {
                    TextField("Naam recept", text: $item.naam)
                        .lineLimit(1)
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
                    
                    if let selectedIngredients = selectedIngredienten, !selectedIngredients.isEmpty {
                        DisclosureGroup("Gekozen ingrediënten (\(selectedIngredients.count))") {
                            ForEach(ingredienten) { ingredient in
                                if selectedIngredients.contains(where: { $0.id == ingredient.id }) {
                                    HStack {
                                        Text(ingredient.naam)
                                        Spacer()
                                        Image(systemName: "minus")
                                            .foregroundColor(Color.accentColor)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        removeIngredient(ingredient)
                                    }
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
                        IngredientListView(selectedIngredienten: $selectedIngredienten)
                    }
                }
                
                Section {
                    Stepper("Porties: \(item.porties)", value: $item.porties, in: 1...8)
                }
                
                
                // Text uitleg
                Section {
                    ForEach(item.uitleg.indices, id: \.self) { index in
                        TextField("Uitleg stap \(index + 1)", text: Binding(
                            get: {
                                guard index < item.uitleg.count else {
                                    return ""
                                }
                                return item.uitleg[index]
                            },
                            set: { newValue in
                                // Ensure the index is within bounds before updating
                                guard index < item.uitleg.count else {
                                    return
                                }
                                item.uitleg[index] = newValue
                            }
                        ), axis: .vertical)
                        .lineLimit(2...6)
                        
                    }
                    .onDelete { indexSet in
                        // Ensure indices are within bounds before removing
                        let validIndices = indexSet.filter { $0 < item.uitleg.count }
                        item.uitleg.remove(atOffsets: IndexSet(validIndices))
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
                
                Color(.clear)
                    .frame(height: 150)
                    .listRowBackground(EmptyView())
                
            }
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        cancelChanges()
                        dismiss()
                    } label: {
                        Text("Terug")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveChanges()
                        dismiss()
                    } label: {
                        Text("\(title)")
                            .foregroundColor(item.naam.isEmpty || item.image == nil ? Color.gray : Color.accentColor)
                    }
                    .disabled(item.naam.isEmpty || item.image == nil)
                }
                
            }
            .onAppear(perform: {
                originalItem = item.copy()
                selectedIngredienten = item.ingredienten
            })
            .task(id: SelectedPhoto){
                if let data = try? await SelectedPhoto?.loadTransferable(type: Data.self) {
                    item.image = data
                }
                   
            }
        }
        
    }
    
    func removeIngredient(_ ingredient: IngredientItem) {
        selectedIngredienten?.removeAll { $0.id == ingredient.id }
    }

    private func cancelChanges() {
        if let originalItem = originalItem {
            item.naam = originalItem.naam
            item.isGezond = originalItem.isGezond
            item.lekker = originalItem.lekker
            item.isVega = originalItem.isVega
            item.tijd = originalItem.tijd
            item.porties = originalItem.porties
            item.uitleg = originalItem.uitleg
            item.isBoodschap = originalItem.isBoodschap
            item.image = originalItem.image
        }
    }
    
    private func saveChanges() {
        if !item.naam.isEmpty, item.image != nil {
            item.ingredienten = selectedIngredienten
            withAnimation {
                context.insert(item)
            }
        }
    }
}
