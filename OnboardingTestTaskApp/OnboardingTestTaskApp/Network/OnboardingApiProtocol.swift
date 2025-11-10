//
//  OnboardingApiProtocol.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import Foundation

protocol OnboardingApiProtocol {
    func fetchOnboarding(from url: URL) async throws -> [OnboardingItem]
}
