//
//  SaveScreenViewController.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

// MARK: - SaveScreenViewController
final class SaveScreenViewController: UIViewController {
    
    // MARK: - Callbacks
    var onSubscribe: (() -> Void)?
    var onClose: (() -> Void)?
    var onPrivacy: (() -> Void)?
    var onTerms: (() -> Void)?
    var onSubscriptionTerms: (() -> Void)?
    
    // MARK: - UI
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let startButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    private let termsLabel = UILabel()
    private let linksTextView = UITextView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    
    // MARK: - Actions
    @objc private func didTapStart() { onSubscribe?() }
    @objc private func didTapClose() { onClose?() }
}

// MARK: - Setup
private extension SaveScreenViewController {
    func setupViews() {
        imageView.image = UIImage(named: "onboarding_illustration")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel.text = String(localized: .premiumTitle)
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .primaryText
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        setupSubtitleLabel()
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .left

        startButton.backgroundColor = .buttonSelectedBG
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle(String(localized: .startNowButtonTitle), for: .normal)
        startButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        startButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        startButton.clipsToBounds = true

        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 16))), for: .normal)
        closeButton.tintColor = .icon
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)

        termsLabel.text = String(localized: .footerBodyText)
        termsLabel.font = .systemFont(ofSize: 12)
        termsLabel.textColor = .bodyText
        termsLabel.textAlignment = .center
        
        setupLinksTextView()
        linksTextView.backgroundColor = .clear
        linksTextView.isEditable = false
        linksTextView.isSelectable = false
        linksTextView.isScrollEnabled = false
        linksTextView.textAlignment = .center
        
        [imageView, titleLabel, subtitleLabel, startButton, closeButton, termsLabel, linksTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func setupSubtitleLabel() {
        let fullText = String(localized: .premiumBodyText)
        let priceText = String(localized: .premiumPriceText)
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let regularFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        
        let fullRange = (fullText as NSString).range(of: fullText)
        attributedString.addAttributes([.font: regularFont, .foregroundColor: UIColor.bodyText], range: fullRange)
        
        if let priceRange = fullText.range(of: priceText) {
            let nsRange = NSRange(priceRange, in: fullText)
            attributedString.addAttributes([.font: boldFont, .foregroundColor: UIColor.primaryText], range: nsRange)
        }
        
        subtitleLabel.attributedText = attributedString
    }
    
    func setupLinksTextView() {
        let text = String(localized: .footerLinksBodyText)
        let link1 = String(localized: .termsText)
        let link2 = String(localized: .privacyText)
        let link3 = String(localized: .subscriptionText)

        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = (text as NSString).range(of: text)

        // Base style
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.bodyText], range: fullRange)

        // Link style
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.linkText,
            .underlineStyle: 0
        ]
        
        // Terms of Use link
        if let range1 = text.range(of: link1) {
            let nsRange = NSRange(range1, in: text)
            attributedString.addAttributes(linkAttributes, range: nsRange)
            attributedString.addAttribute(.link, value: Constants.exampleURL, range: nsRange)
        }
        
        // Privacy Policy link
        if let range2 = text.range(of: link2) {
            let nsRange = NSRange(range2, in: text)
            attributedString.addAttributes(linkAttributes, range: nsRange)
            attributedString.addAttribute(.link, value: Constants.exampleURL, range: nsRange)
        }
        
        // Subscription Terms link
        if let range3 = text.range(of: link3) {
            let nsRange = NSRange(range3, in: text)
            attributedString.addAttributes(linkAttributes, range: nsRange)
            attributedString.addAttribute(.link, value: Constants.exampleURL, range: nsRange)
        }

        linksTextView.attributedText = attributedString
        linksTextView.linkTextAttributes = linkAttributes
    }

    func setupConstraints() {
        let padding: CGFloat = 24
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 16),

            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            
            startButton.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: padding),
            startButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            startButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            startButton.heightAnchor.constraint(equalToConstant: 56),

            termsLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            termsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: safe.leadingAnchor, constant: padding),
            termsLabel.trailingAnchor.constraint(lessThanOrEqualTo: safe.trailingAnchor, constant: -padding),
            
            linksTextView.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: -4),
            linksTextView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: padding),
            linksTextView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -padding),
            linksTextView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 0)
        ])
    }
}
