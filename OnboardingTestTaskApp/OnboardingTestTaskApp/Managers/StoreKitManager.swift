//
//  StoreKitManager.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 13.11.2025.
//

import StoreKit

@MainActor
final class StoreKitManager {
    static let shared = StoreKitManager()
    private init() {}
    
    var onSubscriptionActivated: (() -> Void)?
    
    private var cachedProducts: [String: Product] = [:]
    
    // MARK: - Setup
    func start() {
        Task {
            await listenForTransactions()
        }
    }
    
    // MARK: - Fetch
    func fetchProduct(withID id: String) async throws -> Product {
        if let cached = cachedProducts[id] {
            return cached
        }
        
        let products = try await Product.products(for: [id])
        
        guard let product = products.first else {
            throw StoreError.productNotFound
        }
        
        cachedProducts[id] = product
        
        return product
    }
    
    // MARK: - Purchase
    func purchase(productID id: String) async throws {
        let product = try await fetchProduct(withID: id)
        
        let result = try await product.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            onSubscriptionActivated?()
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            throw StoreError.pending
        @unknown default:
            throw StoreError.unknown
        }
    }
    
    // MARK: - Transaction Updates
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)
                await transaction.finish()
                onSubscriptionActivated?()
                print("Restored / updated transaction handled")
            } catch {
                print("Transaction verification failed:", error)
            }
        }
    }
    
    // MARK: - Helpers
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreError.unverifiedTransaction
        }
    }
    
    enum StoreError: Error {
        case productNotFound
        case unverifiedTransaction
        case userCancelled
        case pending
        case unknown
    }
}

