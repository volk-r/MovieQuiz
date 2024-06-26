//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Roman Romanov on 19.05.2024.
//

import UIKit

final class MovieQuizPresenter {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var currentQuestion: QuizQuestion?
    
    private lazy var statisticService: StatisticService = StatisticServiceImplementation()
    
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        loadData()
    }
    
    // MARK: - public functions
    
    func showAnswerResult(isCorrect: Bool) {
        guard let currentQuestion else { return }
        
        let isCorrectAnswer = isCorrect == currentQuestion.correctAnswer
        
        didAnswer(isCorrectAnswer: isCorrectAnswer)
        
        viewController?.allowButtonsClick(false)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrectAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.showNextQuestionOrResults()
            
            self.viewController?.hideImageBorder()
            self.viewController?.allowButtonsClick(true)
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}

// MARK: - private functions

extension MovieQuizPresenter {    
    private func loadData() {
        viewController?.showLoadingIndicator()
        Task {
            await questionFactory?.loadData()
        }
    }
    
    private func restartGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    private func showNextQuestionOrResults() {
        guard isLastQuestion() else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            
            return
        }
        
        let message = makeResultsMessage()
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self else { return }
                
                self.restartGame()
            }
        
        viewController?.showAlert(model: model)
    }
    
    private func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString)
            Срендяя точность \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
        
        return message
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        
        viewController?.hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self else { return }
                
                self.restartGame()
                // load data one more time
                self.loadData()
            }
        
        viewController?.showAlert(model: model)
    }
}
