//
//  ReceptFormView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import PhotosUI

struct ReceptListView: View {
    @Bindable var item: ReceptItem
    @State private var isPickerPresented = false
    
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
                                .aspectRatio(170/130, contentMode: .fill)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                )
                                .padding([.top, .bottom], 5)

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
                        isImageAdded?.wrappedValue = false
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
                TextField("Ingredient", text: $item.ingredienten)
            }
            
            
            Section(header: Text("Voeg stappen toe")) {
                ForEach(item.uitleg.indices, id: \.self) { index in
                    TextEditor(text: $item.uitleg[index])
                        .frame(height: 40)
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
