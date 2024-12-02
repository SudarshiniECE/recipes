//
//  Recipe.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 24/11/24.
//

import Foundation

//struct RecipeResponse: Codable {
//    let recipes: [Recipe]
//}
//
//struct Recipe: Codable,Identifiable {
//    var id: UUID?
//    let cuisine: String?
//    let name: String?
//    let photo_url_small: String?
//    let photo_url_large: String?
//    let uuid: String?
//    let source_url: String?
//    let youtube_url: String?
//}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    let id: String       // Assuming the 'uuid' is used as the unique identifier
    let name: String
    let cuisine: String
    let photo_url_small: String?
    let photo_url_large: String?
    let source_url: String?
    let youtube_url: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photo_url_small
        case photo_url_large
        case source_url
        case youtube_url
    }
}
