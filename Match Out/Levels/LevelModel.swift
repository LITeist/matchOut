//
//  LevelModel.swift
//  Match Out
//
//  Created by Леванов Алексей on 24.08.2022.
//

import Foundation

/// Тип карты
enum LevelColorType: String, Decodable {
    case lightGreen        = "green"
    case tortureRed        = "red"
    case cosmicBlue        = "blue"
    case blackNour         = "black"
    case simpleBrown       = "brown"
} 

///// Структура для парсинга уровней из JSON
//struct LevelModel: Decodable {
//    let mapType: LevelType  // Тип карты
//    let optimumNumberOfSteps: Int // За сколько шагов можно в идеале пройти игру
//    let luquidContainers: Array<ContainerModel>    // Набор моделей контейнера для игры
//    let chemistryEnabled: String?
//    let numberOfHeatsEnabled: Int? // сколько нагреваний доступно
//}
