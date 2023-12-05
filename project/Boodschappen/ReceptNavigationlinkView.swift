//
//  ReceptNavigationlinkView.swift
//  project
//
//  Created by Salome Poulain on 05/12/2023.
//

import SwiftUI

struct ReceptNavigationlinkView: View {
    
    @Bindable var recept: ReceptItem
    
    var body: some View {
        
        HStack {
            
            if let imageData = recept.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                    .clipShape(Rectangle())
                    .padding(.trailing, 5)
            }
                
            
            Text(recept.naam)
                .lineLimit(2)

            Spacer()
            
        }
        .frame(width: 240)
        
        
    }
}
