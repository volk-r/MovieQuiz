//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Roman Romanov on 01.05.2024.
//

import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchAsync(url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        if let response = response as? HTTPURLResponse,
            response.statusCode < 200 || response.statusCode >= 300 {
            throw NetworkError.codeError
        }
        
        return data
    }
}
