//
//  LevelModel.swift
//  Match Out
//
//  Created by Леванов Алексей on 24.08.2022.
//

// "matchType": 0 или 1 определяет лежит ли там спичка или нет. Если 1 - лежит, рисуем и плейсхолдер под ней
// Если 0 - не лежит, но может
// "matchAngle": 0 - угол поворота в градусах. 0 - горизонтально лежит, 180 - тоже горизонтально, в другую сторону, 90 и 270 - вертикально
// x, y - центр спрайта
import Foundation

/// Тип карты
enum LevelColorType: String, Decodable {
    case green         = "green"
    case red           = "red"
    case orange        = "orange"
    case gray          = "gray"
    case pink          = "pink"
} 

/// Структура для парсинга уровней из JSON
struct LevelModel: Decodable {
    let levelType: LevelColorType  // Тип уровня
    let description: String
    let extraMatches: Int // Сколько экстра спичек
    let matches: Array<matchModel>    // Набор моделей контейнера для игры
}

struct matchModel: Decodable {
    let matchType: Int // Тип спички
    let x: Float
    let y: Float
    let matchAngle: String
}
