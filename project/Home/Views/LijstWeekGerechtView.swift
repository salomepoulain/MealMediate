//
//  LijstWeekGerechtView.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI

struct LijstWeekGerechtView: View {
    
    @Bindable var receptItem: ReceptItem
    
    var body: some View {
        HStack {
            if let imageData = receptItem.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 100)
                    .clipShape(Rectangle())
                    .cornerRadius(10)
                    .padding(.leading, -5)
            }
            
            VStack(){
            
                HStack{
                    Text(receptItem.naam)
                        .foregroundColor(Color.primary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .font(.system(size: 15))
                        
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
            .padding(15)
        }
    }
}
