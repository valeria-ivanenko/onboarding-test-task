//
//  RootViewModel.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 13.11.2025.
//

import Foundation

// MARK: - RootViewModel
final class RootViewModel {
    var onItemsLoaded: (([OnboardingItem]) -> Void)?
    var onError: ((Error) -> Void)?

    private(set) var items: [OnboardingItem] = []

    func startPrefetch() {
        Task {
            await fetch()
        }
    }
}

// MARK: - Private
private extension RootViewModel {
    func fetch() async {
        do {
            let items = try await OnboardingAPI.shared.fetchOnboarding(from: Constants.apiURL)
            self.items = items
            onItemsLoaded?(items)
        } catch {
            onError?(error)
        }
    }
}
