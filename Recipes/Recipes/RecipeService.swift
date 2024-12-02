//
//  RecipeService.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 24/11/24.
//

import Foundation

class RecipeService {
    private let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    private var session: NetworkSession  // Use protocol type instead of URLSession

    // Dependency Injection for NetworkSession
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        do {
            print("Fetching recipes...")
            let (data, response) = try await session.data(from: url)
            
            // Check for HTTP response status
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                throw URLError(.badServerResponse)
            }
            do {
                let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                
                // Check if recipes list is empty
                guard !recipeResponse.recipes.isEmpty else {
                    throw RecipeServiceError.emptyData
                }
                
                
                return recipeResponse.recipes
            } catch {
                // Handle malformed data
                if (error as? DecodingError) != nil {
                    throw RecipeServiceError.malformedData
                }
                throw error
            }
        }
    }
}
// Define custom error cases
enum RecipeServiceError: Error, LocalizedError {
    case malformedData
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .malformedData:
            return "Data received from the server is corrupted."
        case .emptyData:
            return "No recipes available."
        }
    }
}
