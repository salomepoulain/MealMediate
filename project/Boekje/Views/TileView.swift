//
//  TileView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct TileView: View {
    
    @Bindable var receptItem: ReceptItem
    
    var body: some View {
        VStack {
            // Top half: Image
            if let imageData = receptItem.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170, height: 130)
                    .clipShape(Rectangle())
            }
            
            // Bottom half: Info
            VStack(){
            
                HStack{
                    Text(receptItem.naam)
                        .foregroundColor(Color.primary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .bold()
                        .font(.system(size: 14))
                        
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    
                    if receptItem.isGezond == true {
                        Image("brocolli")
                            .foregroundColor(Color("IconGreen"))
                    } else {
                        Image("hamburger")
                            .foregroundColor(Color("IconRed"))
                    }
                    
                    if receptItem.lekker == 1 {
                        Image("bad")
                            .foregroundColor(Color("IconRed"))
                    } else if receptItem.lekker == 2 {
                        Image("mid")
                            .foregroundColor(Color("IconMedium"))
                    } else if receptItem.lekker == 3 {
                        Image("good")
                            .foregroundColor(Color("IconGreen"))
                    }
                    
                    if receptItem.isVega == true {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(Color("IconGreen"))
                    }
                    
                    Spacer()
                    
                    Text("\(receptItem.tijd*5) min")
                        .font(.system(size: 14))
                }
            }
            .padding([.bottom, .leading, .trailing], 11)
            .frame(width: 170, height: 80)
        }
        .frame(width: 170, height: 210)
        .background(Color("Tile"))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}



