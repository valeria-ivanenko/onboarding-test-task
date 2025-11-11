//
//  QuestionCardViewController.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

//MARK: - QuestionCardViewController
final class QuestionCardViewController: UIViewController {
    //MARK: - Fields
    private let item: OnboardingItem
    private var selectedButton: AnswerButton?
    private var selectedAnswer: String? { didSet { updateContinueButtonState(enabled: selectedAnswer != nil) } }

    var onContinue: ((String) -> Void)?
    
    //MARK: - UI
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let answersStack = UIStackView()
    private let continueButton = UIButton(type: .system)
    
    //MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
    }

    // MARK: - Inits
    init(item: OnboardingItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.item = .init(id: 0, question: "", answers: [])
        super.init(coder: coder)
    }
}

// MARK: - Setup
private extension QuestionCardViewController {
    func setup() {
        view.backgroundColor = .appBackground
        setupTitle()
        setupSubtitle()
        setupAnswers()
        setupContinueButton()
        setupConstraints()
    }
    
    func setupTitle() {
        titleLabel.text = String(localized: .onboardingTitle)
        titleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
    }
    
    func setupSubtitle() {
        subtitleLabel.text = item.question
        subtitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)
    }
    
    func setupAnswers() {
        answersStack.axis = .vertical
        answersStack.spacing = 12
        answersStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(answersStack)
        
        for answer in item.answers {
            let button = AnswerButton()
            button.setTitle(answer, for: .normal)
            button.addTarget(self, action: #selector(answerTapped(_:)), for: .touchUpInside)
            answersStack.addArrangedSubview(button)
        }
    }
    
    func setupContinueButton() {
        continueButton.setTitle(String(localized: .continueButtonTitle), for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        continueButton.backgroundColor = UIColor.buttonDefaultBG
        continueButton.setTitleColor(.lightGray, for: .normal)
        continueButton.isEnabled = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        continueButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 8)
        continueButton.layer.shadowRadius = 16
        continueButton.layer.shadowOpacity = 1
        view.addSubview(continueButton)
    }
    
    func setupConstraints() {
        let padding: CGFloat = 24
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            subtitleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            
            answersStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            answersStack.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            answersStack.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            
            continueButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -48),
            continueButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            continueButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            continueButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

// MARK: - Actions
private extension QuestionCardViewController {
    @objc func answerTapped(_ sender: AnswerButton) {
        // Deselect previously selected button
        selectedButton?.isSelected = false
        sender.isSelected = true
        selectedButton = sender
        selectedAnswer = sender.title(for: .normal)
    }
    
    @objc func didTapContinue() {
        guard let selected = selectedAnswer else { return }
        onContinue?(selected)
    }
    
    func updateContinueButtonState(enabled: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.continueButton.isEnabled = enabled
            self.continueButton.backgroundColor = enabled ? UIColor.buttonSelectedBG : UIColor.buttonDefaultBG
            self.continueButton.setTitleColor(enabled ? .constWhite : .lightGray, for: .normal)
        }
    }
}
