//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Roman Romanov on 21.05.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    func hideImageBorder()
    
    func allowButtonsClick(_ isEnabled: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showAlert(model: AlertModel)
}
