//
//  MockNetworkSession.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 30/11/24.
//


import Foundation

// Mocking NetworkSession for unit tests
class MockNetworkSession: NetworkSession {
    var mockData: Data?
    var mockResponse: HTTPURLResponse?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let mockData = mockData, let mockResponse = mockResponse else {
            throw URLError(.badServerResponse)
        }
        return (mockData, mockResponse)
    }
}
