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
    var tile_vega: Bool
    var tile_tijd: String
    
    init(tile_naam: String, tile_gezond: Bool, tile_vega: Bool, tile_tijd: String) {
        self.tile_naam = tile_naam
        self.tile_gezond = tile_gezond
        self.tile_vega = tile_vega
        self.tile_tijd = tile_tijd
    }
    
    var body: some View {
        VStack {
            // Top half: Image
            Rectangle()
                .fill(Color.green)
                .frame(width: 170, height: 130)
            
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
                        Image("apple")
                            .foregroundColor(.green)
                    } else {
                        Image("apple")
                            .foregroundColor(.red)
                    }
                    
                    if tile_vega == true {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(tile_tijd) min")
                        .font(.system(size: 14))
                }
            }
            .padding([.bottom, .leading, .trailing], 11)
            .frame(width: 170, height: 80)
        }
        .frame(width: 170, height: 210)
        .background(Color.white)
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    TileView(tile_naam: "kip samurai", tile_gezond: true, tile_vega: false, tile_tijd: "120")
        .contextMenu {
            // button 1
            Button(action: {
                // TODO
                print("Other menu item")
            }) {
                Label("Wijzig", systemImage: "pencil")
            }
            
            //button 2
            Button(role: .destructive) {
                
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 5)
        
        
        
        
        

        
}
