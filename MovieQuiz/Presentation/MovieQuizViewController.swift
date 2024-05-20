import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: PROPERTIES
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let movieQuizView = MovieQuizView()
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = movieQuizView
        setupButton()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - SETUP
    
    private func setupButton() {
        movieQuizView.noButton.addTarget(self, action: #selector(tapNoAction), for: .touchUpInside)
        movieQuizView.yesButton.addTarget(self, action: #selector(tapYesAction), for: .touchUpInside)
    }
    
    @objc private func tapYesAction() {
        presenter.showAnswerResult(isCorrect: true)
    }
    
    @objc private func tapNoAction() {
        presenter.showAnswerResult(isCorrect: false)
    }
}

// MARK: - FUNCTIONS

extension MovieQuizViewController {
    func highlightImageBorder(isCorrectAnswer: Bool) {
        movieQuizView.previewImage.layer.masksToBounds = true
        movieQuizView.previewImage.layer.borderWidth = 8
        movieQuizView.previewImage.layer.borderColor = isCorrectAnswer
        ? UIColor.ypGreen.cgColor
        : UIColor.ypRed.cgColor
        movieQuizView.previewImage.layer.cornerRadius = 20
    }
    
    func hideImageBorder() {
        movieQuizView.previewImage.layer.borderWidth = 0
    }
    
    func allowButtonsClick(_ isEnabled: Bool) {
        movieQuizView.yesButton.isEnabled = isEnabled
        movieQuizView.noButton.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        movieQuizView.activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        movieQuizView.activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let viewModel = QuizResultsViewModel(
            title: "Ошибка",
            text: message,
            buttonText: "Попробовать ещё раз")
        
        showMessage(with: viewModel) { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
            // load data one more time
            self.presenter.loadData()
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        movieQuizView.previewImage.image = step.image
        movieQuizView.questionLabel.text = step.question
        movieQuizView.indexLabel.text = step.questionNumber
    }
    
    func showQuizResults() {
        let message = presenter.makeResultsMessage()
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: message,
            buttonText: "Сыграть ещё раз")
        
        showMessage(with: viewModel) { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
        }
    }
    
    private func showMessage(with model: QuizResultsViewModel, handler: @escaping () -> Void) {
        let model = AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText) {
                handler()
            }
        
        alertPresenter?.callAlert(with: model)
    }
}
