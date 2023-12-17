//
//  LijstWeekGerechtView.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI

struct LijstWeekGerechtView: View {
    
    // MARK: - Properties
    
    @Bindable var receptItem: ReceptItem
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Display recipe image if available
            if !receptItem.image.isEmpty {
                let uiImage = UIImage(data: receptItem.image)
                Image(uiImage: uiImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 130, height: 100)
                    .clipShape(Rectangle())
                    .cornerRadius(8)
                    .padding(.leading, -5)
            }
            
            VStack() {
                // Display recipe name
                HStack {
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
                
                // Display health, taste, and vegetarian indicators along with preparation time
                IndicatorView(receptItem: receptItem)
                
            }
            .padding(15)
        }
    }
}


