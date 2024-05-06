//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Roman Romanov on 04.05.2024.
//

import Foundation

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) async
}

struct MoviesLoader: MoviesLoadingProtocol {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: AppApiConstants.mostPopularMoviesUrl + AppApiConstants.apiKey) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // MARK: - loadMovies with async/await
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) async {
        do {
            let data = try await networkClient.fetchAsync(url: mostPopularMoviesUrl)
            let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)

            if !mostPopularMovies.errorMessage.isEmpty {
                handler(.failure(mostPopularMovies.errorMessage))
                return
            }
            
            handler(.success(mostPopularMovies))
        } catch {
            handler(.failure(error))
        }
    }
}
