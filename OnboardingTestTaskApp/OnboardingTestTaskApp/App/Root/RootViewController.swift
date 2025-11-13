//
//  RootViewController.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

// MARK: - RootViewController
final class RootViewController: UIViewController {
    private let viewModel: RootViewModel
    
    // MARK: - Inits
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = .init()
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground

        viewModel.onItemsLoaded = { [weak self] items in
            self?.navigateToOnboarding(items)
        }

        viewModel.onError = { error in
            print("Error: \(error)\n Sorry! The app is unable to load the onboarding data. Please try again later.")
        }
    }
}

// MARK: - Private
private extension RootViewController {
    func navigateToOnboarding(_ items: [OnboardingItem]) {
        let onboardingVM = OnboardingViewModel(items: items)
        let onboarding = OnboardingCoordinatorViewController(viewModel: onboardingVM)
        navigationController?.setViewControllers([onboarding], animated: true)
    }
}
