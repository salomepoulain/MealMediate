//
//  CreateRecept.swift
//  project
//
//  Created by Salome Poulain on 22/11/2023.
//

import SwiftUI

struct CreateRecept: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context

    @State private var item = ReceptItem()
    
    @State private var isNameEntered: Bool = false
    @State private var isImageAdded: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ReceptListView(item: item, isNameEntered: $isNameEntered, isImageAdded: $isImageAdded)
                .navigationTitle("Creëer recept")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button (action: {
                            dismiss()
                        }, label: {
                            Text("Sluit")
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                context.insert(item)
                            }
                            dismiss()
                        }, label: {
                            Text("Voeg toe")
                                .foregroundColor(isImageAdded ? Color.accentColor : Color.gray)
                        })
                        .disabled(!isNameEntered)
                    }
            }
        }
        .tint(.accentColor)
    }
}

#Preview {
    CreateRecept()
        .modelContainer(for: ReceptItem.self)
}
