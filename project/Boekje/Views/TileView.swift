//
//  TileView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct TileView: View {
    
    var tile_naam: String
    var tile_gezond: Bool
    var tile_lekker: Int
    var tile_vega: Bool
    var tile_tijd: Int
    var tile_image: Data? // New property for image data
    
    init(tile_naam: String, tile_gezond: Bool, tile_lekker: Int, tile_vega: Bool, tile_tijd: Int, tile_image: Data?) {
        self.tile_naam = tile_naam
        self.tile_gezond = tile_gezond
        self.tile_lekker = tile_lekker
        self.tile_vega = tile_vega
        self.tile_tijd = tile_tijd
        self.tile_image = tile_image
    }
    
    var body: some View {
        VStack {
            // Top half: Image
            if let imageData = tile_image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 170, height: 130)
            }
            
            // Bottom half: Info
            VStack(){
            
                HStack{
                    Text(tile_naam)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .bold()
                        .font(.system(size: 14))
                        
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    
                    if tile_gezond == true {
                        Image("brocolli")
                            .foregroundColor(Color("IconGreen"))
                    } else {
                        Image("hamburger")
                            .foregroundColor(Color("IconRed"))
                    }
                    
                    if tile_lekker == 1 {
                        Image("bad")
                            .foregroundColor(Color("IconRed"))
                    } else if tile_lekker == 2 {
                        Image("mid")
                            .foregroundColor(Color("IconMedium"))
                    } else if tile_lekker == 3 {
                        Image("good")
                            .foregroundColor(Color("IconGreen"))
                    }
                    
                    if tile_vega == true {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(Color("IconGreen"))
                    }
                    
                    Spacer()
                    
                    Text("\(tile_tijd*5) min")
                        .font(.system(size: 14))
                }
            }
            .padding([.bottom, .leading, .trailing], 11)
            .frame(width: 170, height: 80)
        }
        .frame(width: 170, height: 210)
        .background(Color.white)
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



