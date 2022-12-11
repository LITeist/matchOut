//
//  UserGameData.swift
//  Match Out
//
//  Created by Леванов Алексей on 03.11.2022.
//


import Foundation
import CoreGraphics

/// Класс для сохранения пользовательского прогресса
class UserGameData: Codable {
    var currentLevel: Int = 14
    var maxReachedLevel: Int = 1
    var numerOfCoins: Int = 1
    var isMusicEnabled: Bool = true
    var isSoundEnabled: Bool = true
    var isAdsInAppPurchasedPaid: Bool = false
}
