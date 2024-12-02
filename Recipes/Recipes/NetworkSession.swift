//
//  NetworkSession.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 30/11/24.
//

// NetworkSession.swift

import Foundation

// Define a protocol for network operations
protocol NetworkSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Default implementation of the NetworkSession protocol using URLSession
extension URLSession: NetworkSession {}

