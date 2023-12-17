// FilterViewModel.swift
// project
//
// Created by Salome Poulain on 17/12/2023.

import Foundation
import SwiftUI

class FilterViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // The selected sort option for filtering
    @Published var selectedSortOption: SortOption
    
    // The sort order (ascending or descending) for filtering
    @Published var sortOrder: SortOption.Order
    
    // The flag to indicate whether the vegetarian filter is applied
    @Published var isVegaFilter: Bool
    
    // The flag to indicate whether the healthy filter is applied
    @Published var isGezondFilter: Bool
    
    // MARK: - Default Values
    
    // Default sort option for resetting filters
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
