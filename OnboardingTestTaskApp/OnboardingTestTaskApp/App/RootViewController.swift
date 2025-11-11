//
//  RootViewController.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit

// MARK: - RootViewController
final class RootViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        Task { await load() }
    }
}

// MARK: - Private
private extension RootViewController {
    func load() async {
        do {
            let items = try await OnboardingAPI.shared.fetchOnboarding(from: Constants.apiURL)
            await MainActor.run {
                self.navigateToOnboarding(items)
            }
        } catch {
            print("Error: \(error)\n Sorry! The app is unable to load the onboarding data. Please try again later.")
        }
    }
    
    func navigateToOnboarding(_ items: [OnboardingItem]) {
        let onboarding = OnboardingCoordinatorViewController(items: items)
        navigationController?.setViewControllers([onboarding], animated: true)
    }
}
