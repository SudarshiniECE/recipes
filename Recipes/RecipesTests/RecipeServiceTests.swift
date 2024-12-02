//
//  RecipeServiceTests.swift
//  RecipesTests
//
//  Created by Sudarshini Venugopal on 30/11/24.
//

// RecipeServiceTests.swift

import XCTest
@testable import Recipes

class RecipeServiceTests: XCTestCase {
    var recipeService: RecipeService!
    var mockSession: MockNetworkSession!
    
    // Helper function to create mock data for testing
    private func createMockRecipeResponse() -> Data? {
        let json = """
        {
            "recipes": [
                {
                    "uuid": "1",
                    "name": "Mock Recipe 1",
                    "cuisine": "Cuisine 1",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com",
                    "youtube_url": "https://youtube.com"
                },
                {
                    "uuid": "2",
                    "name": "Mock Recipe 2",
                    "cuisine": "Cuisine 2",
                    "photo_url_small": "https://example.com/small2.jpg",
                    "photo_url_large": "https://example.com/large2.jpg",
                    "source_url": "https://example2.com",
                    "youtube_url": "https://youtube.com"
                }
            ]
        }
        """
        return json.data(using: .utf8)
    }

    override func setUp() {
        super.setUp()
        mockSession = MockNetworkSession()
    }

    override func tearDown() {
        recipeService = nil
        mockSession = nil
        super.tearDown()
    }

    // Test for valid data from the "recipes.json" endpoint
    func testFetchRecipesSuccess() async {
        // Arrange
        let mockData = createMockRecipeResponse()
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        mockSession.mockData = mockData
        mockSession.mockResponse = mockResponse
        recipeService = RecipeService(session: mockSession)
        
        // Act
        do {
            let recipes = try await recipeService.fetchRecipes()
            
            // Assert
            XCTAssertEqual(recipes.count, 2)
            XCTAssertEqual(recipes.first?.name, "Mock Recipe 1")
            XCTAssertEqual(recipes.last?.name, "Mock Recipe 2")
        } catch {
            XCTFail("Expected successful fetch, but got error: \(error)")
        }
    }


     //Test for empty data from the "recipes-empty.json" endpoint
    func testFetchRecipesEmptyData() async {
        // Arrange
        let emptyJSON = """
        {
            "recipes": []
        }
        """
        mockSession.mockData = emptyJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        recipeService = RecipeService(session: mockSession)

        // Act
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected empty data error, but got no error.")
        } catch let error as RecipeServiceError {
            // Assert
            XCTAssertEqual(error, RecipeServiceError.emptyData, "Expected emptyData error, but got \(error)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // Test for malformed data from the "recipes-malformed.json" endpoint
    func testFetchRecipesMalformedData() async {
        // Arrange
        let malformedJSON = """
        {
            "recipes": [
                {
                    "uuid": "1",
                    "name": "Mock Recipe 1"
                    // Missing fields like 'cuisine' and 'photo_url'
                }
            ]
        }
        """
        mockSession.mockData = malformedJSON.data(using: .utf8)
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        recipeService = RecipeService(session: mockSession)
        // Act
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected error due to malformed data, but succeeded")
        } catch let error as RecipeServiceError {
            // Assert
            XCTAssertEqual(error, RecipeServiceError.malformedData)
        } catch {
            XCTFail("Expected RecipeServiceError, but got a different error: \(error)")
        }
    }
    
    // Test for server error (non-200 response)
    func testFetchRecipesServerError() async {
        // Arrange
        mockSession.mockData = nil
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )
        recipeService = RecipeService(session: mockSession)
        // Act
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected error due to server failure, but succeeded")
        } catch let error as URLError {
            // Assert
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            XCTFail("Expected URLError, but got a different error: \(error)")
        }
    }
}



