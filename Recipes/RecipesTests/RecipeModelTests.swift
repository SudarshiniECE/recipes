//
//  RecipeModelTests.swift
//  RecipesTests
//
//  Created by Sudarshini Venugopal on 28/11/24.
//

import XCTest
@testable import Recipes

class MockRecipeService: RecipeService {
    var shouldFail: Bool = false
    var malformed: Bool = false
    var mockRecipes: [Recipe] = []

    override func fetchRecipes() async throws -> [Recipe] {
        if shouldFail {
            throw URLError(.badServerResponse)
        }
        if malformed {
            throw RecipeServiceError.malformedData
        }
        guard !mockRecipes.isEmpty else {
            throw RecipeServiceError.emptyData
        }
        
        return mockRecipes
    }
}

class RecipeViewModelTests: XCTestCase {
    var viewModel: RecipeViewModel!
    var mockService: MockRecipeService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        viewModel = RecipeViewModel(service: mockService)
    }
    @MainActor
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testLoadRecipesSuccess() async {
        // Arrange
        let mockRecipes = [
            Recipe(
                id: "1",
                name: "Mock Recipe 1",
                cuisine: "Cuisine 1",
                photo_url_small: nil,
                photo_url_large: nil,
                source_url: nil,
                youtube_url: nil
            ),
            Recipe(
                id: "2",
                name: "Mock Recipe 2",
                cuisine: "Cuisine 2",
                photo_url_small: nil,
                photo_url_large: nil,
                source_url: nil,
                youtube_url: nil
            )
        ]
        mockService.mockRecipes = mockRecipes
        mockService.shouldFail = false

        // Act
        await viewModel.loadRecipes()
        
        // Access properties before passing to XCTest
        let recipesCount = await viewModel.recipes.count
        let firstRecipeName = await viewModel.recipes.first?.name
        let secondRecipeCuisine = await viewModel.recipes.last?.cuisine
        let errorMessage = await viewModel.errorMessage
        let urlString = await viewModel.recipes.first?.photo_url_small ?? ""


        // Assert
        XCTAssertEqual(recipesCount, 2)
        XCTAssertNil(errorMessage)
        XCTAssertEqual(firstRecipeName, "Mock Recipe 1")
        XCTAssertEqual(secondRecipeCuisine, "Cuisine 2")
        XCTAssertEqual(urlString, "")
    }

    func testLoadRecipesFailure() async {
        // Arrange
        mockService.shouldFail = true

        // Act
        await viewModel.loadRecipes()
        // Access properties before passing to XCTest
        let recipesCount = await viewModel.recipes.count
        let errorMessage = await viewModel.errorMessage

        // Assert
        XCTAssertEqual(recipesCount, 0)
        XCTAssertEqual(errorMessage, "Server error. Please try again later.")
    }


    
    func testLoadRecipesEmptyData() async {
        // Arrange
        mockService.mockRecipes = [] // Simulating empty data
        mockService.shouldFail = false

        // Act
        await viewModel.loadRecipes()
        
        let recipes = await viewModel.recipes
        let errormessage = await viewModel.errorMessage

        // Assert
        XCTAssertTrue(recipes.isEmpty)
        XCTAssertEqual(errormessage, "No recipes available.")
    }
    func testLoadRecipesMalformed() async {
        // Arrange
        let mockRecipes = [
            Recipe(
                id: "1",
                name: "Mock Recipe 1",
                cuisine: "Cuisine 1",
                photo_url_small: nil, // Nil URL
                photo_url_large: nil,
                source_url: nil,
                youtube_url: nil
            ),
            Recipe(
                id: "2",
                name: "Mock Recipe 2",
                cuisine: "Cuisine 2",
                photo_url_small: "", // Empty string URL
                photo_url_large: nil,
                source_url: nil,
                youtube_url: nil
            )
        ]
        mockService.mockRecipes = mockRecipes
        mockService.shouldFail = false
        mockService.malformed = true

        // Act
        await viewModel.loadRecipes()
        // Access properties before passing to XCTest
        let recipesCount = await viewModel.recipes.count
        let errorMessage = await viewModel.errorMessage

        // Assert
        XCTAssertEqual(recipesCount, 0) // checking if malformed data gives empty recipe
        XCTAssertEqual(errorMessage, "Failed to load recipes due to malformed data.")
    }
    

}


