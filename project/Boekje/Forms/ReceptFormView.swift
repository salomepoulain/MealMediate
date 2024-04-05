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
    
    // MARK: - Environment Variables
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    // Bindable Properties
    @Bindable var item: ReceptItem
    @State private var originalItem: ReceptItem?
    
    // Query for fetching ingredient
    @Query var ingredienten: [IngredientItem]
    
    // State properties
    @State private var selectedIngredienten: [IngredientItem]?
    @State private var isPickerPresented = false
    @State private var isIngredientListViewPresented = false
    @State var SelectedPhoto: PhotosPickerItem?
    
    // Binding for the navigation bar title
    @Binding var title: String

    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            List {
                // Naam Section
                Section {
                    TextField("Naam recept", text: $item.naam)
                        .lineLimit(1)
                }
                
                // Photo Section
                photoSection

                // Options Section
                optionsSection
                
                // Ingredienten Section
                ingredientenSection
                
                // Porties Section
                Section {
                    Stepper("Porties: \(item.porties)", value: $item.porties, in: 1...8)
                }
                
                // Text uitleg Section
                textUitlegSection
                
                // Spacer for better visual separation
                Color(.clear)
                    .frame(height: 100)
                    .listRowBackground(EmptyView())
                
            }
            // Toolbar items for navigation bar
            .toolbar {
                // Keyboard
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()

                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }) {
                            Text("Done")
                        }
                    }
                }
                
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        cancelChanges()
                        dismiss()
                    } label: {
                        Text("Terug")
                    }
                }
                
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveChanges()
                        dismiss()
                    } label: {
                        Text("\(title)")
                            .foregroundColor(item.naam.isEmpty || item.image.isEmpty || item.tijd == 0 ? Color.gray : Color.accentColor)
                    }
                    .disabled(item.naam.isEmpty || item.image.isEmpty || item.tijd == 0)
                }
                
            }
            .onAppear(perform: onAppearTask)
            .task(id: SelectedPhoto){
                if let data = try? await SelectedPhoto?.loadTransferable(type: Data.self) {
                    item.image = data
                }
                   
            }
        }
    }

    // MARK: - Sections

    // Photo Section
    private var photoSection: some View {
        Section {
            PhotosPicker(selection: $SelectedPhoto, matching: .images, photoLibrary: .shared()) {
                if item.image.isEmpty {
                    Label("Voeg foto toe", systemImage: "photo.badge.plus.fill")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        if let uiImage = UIImage(data: item.image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 30, height: 270)
                                .clipped()
                                .padding([.top, .bottom], -15)
                        } else {
                            Image(systemName: "camera.fill")
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding(20)
                        }
                    }
                }
            }

        }
    }

    // Options Section
    private var optionsSection: some View {
        Section {
            Toggle("Gezond", isOn: $item.isGezond)
            
            Toggle("Vegetarisch", isOn: $item.isVega)
            
            VStack {
                HStack {
                    Text("Tijd in minuten")
                    Spacer()
                    Button(action: { isPickerPresented.toggle() }) {
                        Text("\(item.tijd * 5)")
                    }
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
    }

    // Ingredienten Section
    private var ingredientenSection: some View {
        Section {
            if let selected = selectedIngredienten, !selected.isEmpty {
                DisclosureGroup("Gekozen ingrediënten (\(selected.count))") {
                    ForEach(selected, id: \.id) { ingredient in
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
    }

    // Text Uitleg Section
    private var textUitlegSection: some View {
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
    }

    // MARK: - Helper Functions

    // Remove selected ingredient
    func removeIngredient(_ ingredient: IngredientItem) {
        selectedIngredienten?.removeAll { $0.id == ingredient.id }
    }

    // Cancel changes and revert to original values
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

    // Save changes to the context
    private func saveChanges() {
        guard !item.naam.isEmpty, !item.image.isEmpty else {
            // Item cannot be saved if name or image is empty
            return
        }

        if let selected = selectedIngredienten {
            let orderedIngredients = selected.enumerated().sorted { $0.offset < $1.offset }.map { $0.element }
            item.ingredienten = orderedIngredients

            print("Order of item.ingredienten:")
            for (index, ingredient) in (item.ingredienten ?? []).enumerated() {
                print("\(index + 1). \(ingredient.naam)")
            }
        }


        // Save changes to the context with animation
        withAnimation {
            context.insert(item)
        }
    }

    // Additional task to handle the selected photo
    private func onAppearTask() {
        originalItem = item.copy()
        selectedIngredienten = item.ingredienten
    }
}
