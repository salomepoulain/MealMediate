//
//  ReceptFinishedView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI
import SwiftData

struct ReceptFinishedView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    // Bindable property to hold the ReceptItem being displayed
    @Bindable var receptItem: ReceptItem
    
    // State variables for UI interactions
    @State private var showCreate = false
    @State private var receptEdit: ReceptItem?
    @State private var showSuccessMessage = false
    
    // MARK: - Body View
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // Display the image if available
                if !receptItem.image.isEmpty {
                    let uiImage = UIImage(data: receptItem.image)
                    Image(uiImage: uiImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                }
                
                VStack(alignment: .leading) {
                    
                    // Display the name
                    HStack {
                        Text(receptItem.naam)
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // Display icons and information
                    ReceptInfoIcoontjes(receptItem: receptItem)
                    
                    Divider()
                        .padding(15)
                    
                    // Display ingredients information
                    IngredientInfo(receptItem: receptItem)
                    
                    Divider()
                        .padding(15)
                    
                    // Display steps information
                    TextUitleg(receptItem: receptItem)
                }
                .padding(.bottom, 50)
                .frame(width: UIScreen.main.bounds.width*0.9)

            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {

                // Toolbar items for actions
                ToolbarItem {
                    Menu {
                        Button {
                            withAnimation {
                                receptItem.isBoodschap = true
                                showSuccessMessage = true
                            }
                        } label: {
                            Label("Voeg toe aan boodschappen", systemImage: "plus.square.fill")
                        }
                        .disabled(receptItem.isBoodschap)
                    } label: {
                        Label("Voeg toe aan boodschappen", systemImage: receptItem.isBoodschap ? "basket.fill" : "basket")
                    }
                }
                    
                ToolbarItem {
                    Menu {
                        Button {
                            receptEdit = receptItem
                        } label: {
                            Label("Wijzig recept in boekje", systemImage: "pencil")
                        }

                        Button(role: .destructive) {
                            context.delete(receptItem)
                            dismiss()
                        } label: {
                            Label("Verwijder recept uit boekje", systemImage: "trash.fill")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle")
                    }
                }
                
            }
            .alert(isPresented: $showSuccessMessage) {
                Alert(
                    title: Text("Gelukt!"),
                    message: Text("Boodschappen toegevoegd")
                )
            }
            .sheet(item: $receptEdit) {
                receptEdit = nil
            } content: { item in
                UpdateRecept(recept: item)
            }
        }
    }
}

// Subview for displaying icons and information
struct ReceptInfoIcoontjes: View {
    let receptItem: ReceptItem

    var body: some View {
        HStack {
            // Display icons and information based on ReceptItem properties
            if receptItem.isGezond == true {
                Image("brocolli")
                    .foregroundColor(Color("IconGreen"))
                Text("gezond")
            } else {
                Image("hamburger")
                    .foregroundColor(Color("IconRed"))
                Text("ongezond")
            }
            
            if receptItem.lekker == 1 {
                Image("bad")
                    .foregroundColor(Color("IconRed"))
                Text("ok")
            } else if receptItem.lekker == 2 {
                Image("mid")
                    .foregroundColor(Color("IconMedium"))
                Text("lekker")
            } else if receptItem.lekker == 3 {
                Image("good")
                    .foregroundColor(Color("IconGreen"))
                Text("heerlijk")
            }
            
            if receptItem.isVega == true {
                Image(systemName: "leaf.fill")
                    .foregroundColor(Color("IconGreen"))
                Text("vega")
            }
            
            Spacer()
            
            // Display cooking time
            Text("\(receptItem.tijd*5) min")
                .bold()
        }
    }
}

// Subview for displaying ingredients information
struct IngredientInfo: View {
    let receptItem: ReceptItem

    var body: some View {
        if let ingredients = receptItem.ingredienten, !ingredients.isEmpty {
            
            // Display ingredient information if available
            Text("Ingrediënten")
                .bold()
                .padding(.bottom, 10)
            
            ForEach(ingredients, id: \.self) { item in
                HStack {
                    Text("-")
                        .foregroundColor(Color.accentColor)
                        .bold()
                        .padding(1)
                        .padding(.leading, 10)
                    
                    Text(item.naam)
                        .padding(1)
                }
            }
        } else {
            // Display message when no ingredients are available
            Text("Geen ingredienten toegevoegd")
                .foregroundColor(Color.gray)
                .italic()
                .padding(.top, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            
        }
    }
}

// Subview for displaying steps information
struct TextUitleg: View {
    let receptItem: ReceptItem
    
    var body: some View {
        if !receptItem.uitleg.isEmpty && receptItem.uitleg != [""] {
            // Display steps information if available
            VStack(alignment: .leading) {
                HStack {
                    Text("Stappen")
                        .bold()

                    Spacer()

                    Text("\(receptItem.porties)")
                        .bold()
                        .foregroundColor(Color.accentColor)

                    Image(systemName: "fork.knife")
                        .foregroundColor(Color.accentColor)
                }
                .padding(.bottom, 10)

                ForEach(Array(receptItem.uitleg.enumerated()), id: \.1) { index, item in
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(index + 1)")
                            .foregroundColor(.accentColor)
                            .padding(1)
                            .padding(.leading, 10)
                            .bold()

                        Text("\(item)")
                            .padding(1)
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.bottom, 50)
            .frame(width: UIScreen.main.bounds.width * 0.9)
        } else {
            // Display message when no steps are available
            Text("Geen uitleg toegevoegd")
                .foregroundColor(Color.gray)
                .italic()
                .padding(.top, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
