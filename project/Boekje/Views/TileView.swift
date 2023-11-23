//
//  TileView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct TileView: View {
    var body: some View {
        VStack {
            // Top half: Green rectangle
            Rectangle()
                .fill(Color.green)
                .frame(width: 170, height: 130)
            
            // Bottom half: Info
            VStack(){
            
                HStack{
                    Text("Pasta pesto")
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .bold()
                        .font(.system(size: 16))
                        
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    Image(systemName: "carrot.fill")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "carrot.fill")
                        .foregroundColor(.gray)
                    
                    Image(systemName: "carrot.fill")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("230 min")
                        .font(.system(size: 14))
                }
            }
            .padding([.bottom, .leading, .trailing], 11)
            .frame(width: 170, height: 80)
        }
        .frame(width: 170, height: 210)
        .background(Color.white)
        .contextMenu {
            Button(action: {
                // TODO
                print("Other menu item")
            }) {
                Label("Wijzig", systemImage: "pencil")
            }
        }
        .cornerRadius(10)
        .shadow(radius: 4, x: 0, y: 2)
    }
}


#Preview {
    TileView()
}
