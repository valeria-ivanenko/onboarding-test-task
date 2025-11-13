//
//  OnboardingViewModel.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 13.11.2025.
//

import Foundation
import StoreKit

@MainActor
final class OnboardingViewModel {
    // MARK: - Fields
    private(set) var items: [OnboardingItem]

    // MARK: - Callbacks
    var onShowAlert: ((String, String) -> Void)?
    var onSubscriptionActivated: (() -> Void)?

    // MARK: - StoreKit
    private var fetchedProduct: Product?

    // MARK: - Init
    init(items: [OnboardingItem]) {
        self.items = items
        
        StoreKitManager.shared.onSubscriptionActivated = { [weak self] in
            self?.onSubscriptionActivated?()
        }
    }

    // MARK: - Public Methods
    func purchasePremium() async {
        do {
            try await StoreKitManager.shared.purchase(productID: Constants.premiumProductID)
            await showAlert("Success", "Subscription activated.")
        } catch {
            switch error as? StoreKitManager.StoreError {
            case .userCancelled:
                await showAlert("Cancelled", "Purchase cancelled.")
            case .pending:
                await showAlert("Pending", "Purchase pending.")
            default:
                await showAlert("Error", "Purchase failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Private
private extension OnboardingViewModel {
    func showAlert(_ title: String, _ message: String) async {
        onShowAlert?(title, message)
    }
}
