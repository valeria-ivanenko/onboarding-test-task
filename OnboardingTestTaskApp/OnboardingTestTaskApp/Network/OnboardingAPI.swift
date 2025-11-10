//
//  OnboardingAPI.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import Foundation

final class OnboardingAPI: OnboardingApiProtocol {
    static let shared = OnboardingAPI()
    private init() {}

    func fetchOnboarding(from url: URL) async throws -> [OnboardingItem] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(OnboardingResponse.self, from: data)
        return decoded.items
    }
}
