//
//  AnswerButton.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

// MARK: - Answer Button View
final class AnswerButton: UIButton {
    
    // MARK: - Fields
    
    private let cardBackgroundColor = UIColor.cardBackground
    private let selectedBackgroundColor = UIColor.accent
    private let primaryTextColor = UIColor.primaryText
    private let selectedTextColor = UIColor.constWhite
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private
private extension AnswerButton {
    func setupUI() {
        // Padding & Colors
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.contentInsets =  NSDirectionalEdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20)
        buttonConfig.baseBackgroundColor = cardBackgroundColor
        buttonConfig.baseForegroundColor = primaryTextColor
        configuration = buttonConfig
        
        // Font & Title alignment
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        contentHorizontalAlignment = .left
        
        // Shadow
        layer.cornerRadius = 14
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
    }
    
    func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
            var newButtonConfig = self.configuration
            newButtonConfig?.baseBackgroundColor = self.isSelected ? self.selectedBackgroundColor : self.cardBackgroundColor
            newButtonConfig?.baseForegroundColor = self.isSelected ? self.selectedTextColor : self.primaryTextColor
            self.configuration = newButtonConfig
            self.layer.shadowOpacity = self.isSelected ? 0 : 1
        }
    }
}
