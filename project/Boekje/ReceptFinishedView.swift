//
//  ReceptFinishedView.swift
//  project
//
//  Created by Salome Poulain on 29/11/2023.
//

import SwiftUI

struct ReceptFinishedView: View {
    
    var fin_naam: String
    var fin_gezond: Bool
    var fin_lekker: Int
    var fin_vega: Bool
    var fin_tijd: Int
    var fin_uitleg: [String]
    var fin_image: Data?
    
    init(fin_naam: String, fin_gezond: Bool, fin_lekker: Int, fin_vega: Bool, fin_tijd: Int, fin_uitleg: [String], fin_image: Data?) {
        self.fin_naam = fin_naam
        self.fin_gezond = fin_gezond
        self.fin_lekker = fin_lekker
        self.fin_vega = fin_vega
        self.fin_tijd = fin_tijd
        self.fin_uitleg = fin_uitleg
        self.fin_image = fin_image
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if let imageData = fin_image,
                   let uiImage = UIImage(data: imageData) {
                   
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                }
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text(fin_naam)
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        if fin_gezond == true {
                            Image("brocolli")
                                .foregroundColor(Color("IconGreen"))
                            Text("gezond")
                        } else {
                            Image("hamburger")
                                .foregroundColor(Color("IconRed"))
                            Text("ongezond")
                        }
                        
                        
                        if fin_lekker == 1 {
                            Image("bad")
                                .foregroundColor(Color("IconRed"))
                            Text("ok")
                        } else if fin_lekker == 2 {
                            Image("mid")
                                .foregroundColor(Color("IconMedium"))
                            Text("lekker")
                        } else if fin_lekker == 3 {
                            Image("good")
                                .foregroundColor(Color("IconGreen"))
                            Text("heerlijk")
                        }
                        
                        
                        if fin_vega == true {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(Color("IconGreen"))
                            Text("vega")
                        }
                        
                        Spacer()
                        
                        Text("\(fin_tijd*5) min")
                            .bold()
                    }
                    
                    Divider()
                        .padding(10)
                    
                    Text("Ingrediënten:")
                        .bold()
                        .padding(.bottom, 10)
                    
                    // Text(fin_ingredienten)
                    
                    Divider()
                        .padding(10)
                    
                    Text("Stappen")
                        .bold()
                        .padding(.bottom, 10)
                    
                    ForEach(fin_uitleg, id: \.self) { item in
                        Text(item)
                    }
                }
                .frame(width: UIScreen.main.bounds.width*0.9)
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

// #Preview {}
