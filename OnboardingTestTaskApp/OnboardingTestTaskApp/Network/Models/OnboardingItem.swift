//
//  OnboardingItem.swift
//  OnboardingTestTaskApp
//
//  Created by Valeriia Ivanenko on 10.11.2025.
//

import Foundation

struct OnboardingItem: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
