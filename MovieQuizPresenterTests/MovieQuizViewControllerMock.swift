//
//  MovieQuizViewControllerMock.swift
//  MovieQuizPresenterTests
//
//  Created by Roman Romanov on 21.05.2024.
//

import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func hideImageBorder() {
        
    }
    
    func allowButtonsClick(_ isEnabled: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showAlert(model: MovieQuiz.AlertModel) {
        
    }
}
