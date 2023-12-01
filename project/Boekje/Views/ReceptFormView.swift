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
    
    @State private var isPickerPresented = false
    @State private var isIngredientListViewPresented = false
    
    var isNameEntered: Binding<Bool>?
    var isImageAdded: Binding<Bool>?
    
    @State var SelectedPhoto: PhotosPickerItem?

    var body: some View {
        List {
            
            Section(header: Text("Geef naam")) {
                TextField("Zoals: \"Paddenstoelenschotel\"", text: $item.naam)
                    .onChange(of: item.naam) {
                        if !item.naam.isEmpty {
                            isNameEntered?.wrappedValue = true
                        } else {
                            isNameEntered?.wrappedValue = false
                        }
                    }
            }
            
            Section(header: Text("Selecteer foto")) {
                PhotosPicker(selection: $SelectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {

                    if item.image == nil {
                        Label("Voeg foto toe", systemImage: "photo")
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
                
                ForEach(item.ingredienten.unsafelyUnwrapped) { ingredient in
                    Text(ingredient.naam)
                }
                
                Button {
                    isIngredientListViewPresented.toggle()
                   } label: {
                       Text("Kies")
                   }
                   .sheet(isPresented: $isIngredientListViewPresented) {
                        IngredientListView()
                }
            }
            
            
            Section(header: Text("Voeg stappen toe")) {
                ForEach(item.uitleg.indices, id: \.self) { index in
                    TextField("Uitleg stap \(index + 1)", text: $item.uitleg[index], axis: .vertical)
                        .lineLimit(2...4)
                }
                .onDelete { indexSet in
                    item.uitleg.remove(atOffsets: indexSet)
                }
                
                Button(action: {
                       if item.uitleg.allSatisfy({ !$0.isEmpty }) {
                           item.uitleg.append("")
                       }
                   }) {
                    HStack {
                        Spacer()
                        Text("Voeg stap toe")
                            .foregroundColor(item.uitleg.allSatisfy { !$0.isEmpty } ? Color.accentColor : Color.gray)
                        Spacer()
                    }
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
