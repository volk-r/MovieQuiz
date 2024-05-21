//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Roman Romanov on 14.04.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoadingProtocol
    private weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        Task {
            await moviesLoader.loadMovies { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.delegate?.didFailToLoadData(with: error)
                    }
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
