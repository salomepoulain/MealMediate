//
//  WeekGerechtView.swift
//  project
//
//  Created by Salome Poulain on 06/12/2023.
//

import SwiftUI

struct WeekGerechtView: View {
    
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
            }
            
            // Display recipe details
            VStack {
                HStack {
                    Text(receptItem.naam)
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(Color.primary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                Spacer()
                
                // Display health, taste, and vegetarian indicators along with preparation time
                IndicatorView(receptItem: receptItem)
            }
            .padding(15)
        }
        .frame(height: 100)
        .frame(width: UIScreen.main.bounds.width * 0.9 - 20)
        .background(Color("Tile"))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


