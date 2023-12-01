//
//  ContentView.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    // let appOrange: Color = Color(red: 224/255, green: 132/255, blue: 98/255)
    
    var body: some View {
        TabView {
            HomeView()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
        
            Boekje()
            .tabItem {
                Image(systemName: "book.pages.fill")
                Text("Recepten")
            }
        
            HomeView()
            .tabItem {
                Image(systemName: "basket.fill")
                Text("Boodschappen")
            }
        
            IngredientListView()
            .tabItem {
                Image(systemName: "info.circle.fill")
                Text("Gezond")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
