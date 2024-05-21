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

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
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
    
    func show(quiz step: QuizStepViewModel) {
        movieQuizView.previewImage.image = step.image
        movieQuizView.questionLabel.text = step.question
        movieQuizView.indexLabel.text = step.questionNumber
    }
    
    func showAlert(model: AlertModel) {
        alertPresenter?.callAlert(with: model)
    }
}
