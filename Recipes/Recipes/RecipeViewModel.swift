//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 24/11/24.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String?

    private let service : RecipeService
    
    init(service: RecipeService = RecipeService()) {
        self.service = service
    }
    func loadRecipes() async {
        errorMessage = nil
        do {
            recipes = try await service.fetchRecipes()
            errorMessage = nil
        } catch RecipeServiceError.malformedData {
            errorMessage = "Failed to load recipes due to malformed data."
            recipes = []
        } catch RecipeServiceError.emptyData {
            errorMessage = "No recipes available."
            recipes = []
        } catch {
            errorMessage = "Server error. Please try again later."
            print("An unexpected error occurred: \(error.localizedDescription)")
            recipes = []
        }
        print(errorMessage ?? "")
    }
}
