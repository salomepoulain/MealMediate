//
//  IndicatorView.swift
//  project
//
//  Created by Salome Poulain on 17/12/2023.
//

import SwiftUI

struct IndicatorView: View {
    var receptItem: ReceptItem
    
    var body: some View {
        // Recipe Details
        HStack {
            // Health indicator (broccoli for healthy, hamburger for unhealthy)
            if receptItem.isGezond == true {
                Image("brocolli")
                    .foregroundColor(Color("IconGreen"))
            } else {
                Image("hamburger")
                    .foregroundColor(Color("IconRed"))
            }

            // Taste indicator (bad, mid, good based on 'lekker' property)
            switch receptItem.lekker {
            case 1:
                Image("bad").foregroundColor(Color("IconRed"))
            case 2:
                Image("mid").foregroundColor(Color("IconMedium"))
            case 3:
                Image("good").foregroundColor(Color("IconGreen"))
            default:
                EmptyView()
            }

            // Vegetarian indicator
            if receptItem.isVega == true {
                Image(systemName: "leaf.fill")
                    .foregroundColor(Color("IconGreen"))
            }

            Spacer()

            // Display recipe preparation time
            Text("\(receptItem.tijd * 5) min")
                .font(.system(size: 14))
        }
    }
}

