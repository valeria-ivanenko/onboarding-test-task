//
//  OnboardingCoordinatorViewController.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import UIKit
import StoreKit

// MARK: - OnboardingCoordinatorViewController
final class OnboardingCoordinatorViewController: UIViewController {
    // MARK: - UI
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pages: [UIViewController] = []
    
    // MARK: - Fields
    private var items: [OnboardingItem]
    private var answersStorage: [Int: String] = [:]
    private var fetchedProduct: Product?
    
    // MARK: - Inits
    init(items: [OnboardingItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        setupPages()
    }
    
    required init?(coder: NSCoder) {
        self.items = []
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
    }
}

// MARK: - Setup
private extension OnboardingCoordinatorViewController {
    func setupPageVC() {
        addChild(pageVC)
        
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageVC.view)
        
        NSLayoutConstraint.activate([
            pageVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        pageVC.didMove(toParent: self)
        
        for sub in pageVC.view.subviews {
            (sub as? UIScrollView)?.isScrollEnabled = false
        }
        
        if let first = pages.first {
            pageVC.setViewControllers([first], direction: .forward, animated: false)
        }
    }
    
    func setupPages() {
        pages = items.map { item in
            let cardVC = QuestionCardViewController(item: item)
            cardVC.onContinue = { [weak self] answer in
                self?.answersStorage[item.id] = answer
                self?.goForward(from: cardVC)
            }
            return cardVC
        }
        
        let saveVC = SaveScreenViewController()
        
        saveVC.onSubscribe = { [weak self] in Task { await self?.purchasePremium() } }
        saveVC.onClose = { [weak self] in self?.finishOnboarding() }
        
        pages.append(saveVC)
    }
}

// MARK: - Coordination
private extension OnboardingCoordinatorViewController {
    func goForward(from current: UIViewController) {
        guard let i = pages.firstIndex(of: current), i + 1 < pages.count else { return }
        pageVC.setViewControllers([pages[i + 1]],
                                  direction: .forward,
                                  animated: true)
    }
    
    func finishOnboarding() {
        print("Answers:", answersStorage)
        
        let doneVC = UIViewController()
        doneVC.view.backgroundColor = .appBackground
        
        let label = UILabel()
        label.text = "Onboarding completed"
        label.translatesAutoresizingMaskIntoConstraints = false
        doneVC.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: doneVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: doneVC.view.centerYAnchor)
        ])
        
        navigationController?.setViewControllers([doneVC], animated: true)
    }
}

// MARK: StoreKit 2
private extension OnboardingCoordinatorViewController {
    func fetchProduct() async {
        do {
            let products = try await Product.products(for: [Constants.premiumProductID])
            fetchedProduct = products.first
        } catch {
            print("Fetch products failed:", error)
        }
    }
    
    func purchasePremium() async {
        await fetchProduct()
        guard let product = fetchedProduct else { await showAlert("Error", "Product not available."); return }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success:
                await showAlert("Success", "Subscription activated.")
            case .userCancelled:
                await showAlert("Cancelled", "Purchase cancelled.")
            case .pending:
                await showAlert("Pending", "Purchase pending.")
            @unknown default:
                await showAlert("Error", "Unknown result.")
            }
        } catch {
            await showAlert("Error", "Purchase failed: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func showAlert(_ title: String, _ message: String) async {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
