// FilterViewModel.swift
// project
//
// Created by Salome Poulain on 17/12/2023.

import Foundation
import SwiftUI

class FilterViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var selectedSortOption: SortOption
    @Published var sortOrder: SortOption.Order
    @Published var isVegaFilter: Bool
    @Published var isGezondFilter: Bool
    
    // MARK: - Default Values
    
    private var defaultSortOption: SortOption
    
    // Default sort order for resetting filters
    private var defaultSortOrder: SortOption.Order
    // Default value for the vegetarian filter for resetting filters
    private var defaultIsVegaFilter: Bool
    // Default value for the healthy filter for resetting filters
    private var defaultIsGezondFilter: Bool
    
    // MARK: - Initialization
    
    init(
        defaultSortOption: SortOption,
        defaultSortOrder: SortOption.Order,
        defaultIsVegaFilter: Bool,
        defaultIsGezondFilter: Bool
    ) {
        // Initialize default values
        self.defaultSortOption = defaultSortOption
        self.defaultSortOrder = defaultSortOrder
        self.defaultIsVegaFilter = defaultIsVegaFilter
        self.defaultIsGezondFilter = defaultIsGezondFilter

        // Initialize published properties with default values
        self.selectedSortOption = defaultSortOption
        self.sortOrder = defaultSortOrder
        self.isVegaFilter = defaultIsVegaFilter
        self.isGezondFilter = defaultIsGezondFilter
    }

    // MARK: - Computed Properties
    
    // Check if filters are in their default state
    var areFiltersDefault: Bool {
        return selectedSortOption == defaultSortOption &&
               sortOrder == defaultSortOrder &&
               isVegaFilter == defaultIsVegaFilter &&
               isGezondFilter == defaultIsGezondFilter
    }
    
    // MARK: - Public Methods
    
    // Reset all filters to their default values
    func resetFilters() {
        selectedSortOption = defaultSortOption
        sortOrder = defaultSortOrder
        isVegaFilter = defaultIsVegaFilter
        isGezondFilter = defaultIsGezondFilter
    }
}
