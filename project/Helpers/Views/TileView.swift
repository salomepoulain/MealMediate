//
//  TileView.swift
//  project
//
//  Created by Salome Poulain on 17/12/2023.
//

import SwiftUI

struct TileView: View {
    
    // MARK: - Properties
    
    @Bindable var receptItem: ReceptItem
    var backgroundColor: Color
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Top half: Image
            if !receptItem.image.isEmpty {
                let uiImage = UIImage(data: receptItem.image)
                Image(uiImage: uiImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170, height: 130)
                    .clipShape(Rectangle())
            }
            
            // Bottom half: Info
            VStack() {
                HStack {
                    Text(receptItem.naam)
                        .foregroundColor(Color.primary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .bold()
                        .font(.system(size: 14))
                    Spacer()
                }
                
                Spacer()
                
                IndicatorView(receptItem: receptItem)
                
            }
            .padding([.bottom, .leading, .trailing], 11)
            .frame(width: 170, height: 80)
        }
        .frame(width: 170, height: 210)
        .background(backgroundColor)
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

