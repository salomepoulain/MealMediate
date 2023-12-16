//
//  ContentView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Home()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
        
            Boekje()
                .tabItem {
                Image(systemName: "book.pages.fill")
                Text("Recepten")
            }
        
            Boodschappen()
            .tabItem {
                Image(systemName: "basket.fill")
                Text("Boodschappen")
            }
        
            Website()
            .tabItem {
                Image(systemName: "info.circle.fill")
                Text("Gezond")
            }
        }
        .tint(Color("AccentColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
