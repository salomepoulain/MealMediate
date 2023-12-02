//
//  ReceptFinishedView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI

struct ReceptFinishedView: View {
    
    @Bindable var receptItem: ReceptItem
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if let imageData = receptItem.image,
                   let uiImage = UIImage(data: imageData) {
                   
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                }
                
                VStack(alignment: .leading) {
                    
                    // naam
                    HStack {
                        Text(receptItem.naam)
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // icoontjes info
                    HStack {
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
                        
                        Text("\(receptItem.tijd*5) min")
                            .bold()
                    }
                    
                    Divider()
                        .padding(15)
                    
                    // ingredienten
                    Text("Ingrediënten")
                        .bold()
                        .padding(.bottom, 10)
                    
                    if let ingredients = receptItem.ingredienten {
                        ForEach(ingredients, id: \.self) { item in
                            HStack {
                                Text("-")
                                //Image(systemName: "circle")
                                    .foregroundColor(Color.accentColor)
                                    .bold()
                                    .padding(1)
                                    .padding(.leading, 10)

                                Text(item.naam)
                                    .padding(1)
                            }
                        }
                    }
                    
                    Divider()
                        .padding(15)
                    
                    // uitleg
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
                        HStack {
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
                .frame(width: UIScreen.main.bounds.width*0.9)
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

// #Preview {}