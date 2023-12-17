//
//  SortFilterSheet.swift
//  project
//
//  Created by Salome Poulain on 17/12/2023.
//

import Foundation
import SwiftUI

// MARK: - FilterSheetView

// View responsible for displaying the filter sheet to sort and filter ReceptItems
struct FilterSheetView: View {
    
    // ObservedObject to track changes in the FilterViewModel
    @ObservedObject var filterViewModel: FilterViewModel

    var body: some View {
        NavigationView {
            List {
                // MARK: - Sorting Section

                Section("Sorteren") {
                    // Picker for selecting the sort option
                    Picker("Sorteren op", selection: $filterViewModel.selectedSortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                                .tag(option)
                        }
                    }

                    // Picker for selecting the sort order
                    Picker("Volgorde", selection: $filterViewModel.sortOrder) {
                        Text("Oplopend").tag(SortOption.Order.ascending)
                        Text("Aflopend").tag(SortOption.Order.descending)
                    }
                }

                // MARK: - Filtering Section

                Section("Filter") {
                    // Toggle for the "Gezond" (Healthy) filter
                    Toggle("Gezond", isOn: $filterViewModel.isGezondFilter)

                    // Toggle for the "Vegetarisch" (Vegetarian) filter
                    Toggle("Vegetarisch", isOn: $filterViewModel.isVegaFilter)
                }

                // MARK: - Reset Filters Section

                Section {
                    // Button to reset filters to default values
                    Button("Reset filters") {
                        if !filterViewModel.areFiltersDefault {
                            filterViewModel.resetFilters()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(filterViewModel.areFiltersDefault ? .gray : .red)
                    .disabled(filterViewModel.areFiltersDefault)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

