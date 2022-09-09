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


/// Размер спички на уровне
enum MatchSize: String, Decodable {
    case extraSmall   = "extraSmall"
    case small        = "small"
    case medium       = "medium"
    case big          = "big"
}

/// Тип игрового уровня - можно только убирать спички или добавлять/убирать
enum LevelGameType: String, Decodable {
    case add           = "add"
    case remove        = "remove"
    case move          = "move"
}

/// Структура для парсинга уровней из JSON
struct LevelModel: Decodable {
    let levelType: LevelColorType  // Тип уровня по цвету
    let gameplayType: LevelGameType // Тип уровня по геймплею
    let matchSize: MatchSize
    let description: String
    let extraMatches: Int // Сколько экстра спичек
    let matches: Array<matchModel>    // Набор моделей контейнера для игры
    let resolves: Array<solveModel>   // Набор решений
}

struct matchModel: Decodable {
    let matchType: Int // Тип спички
    let x: Float
    let y: Float
    let matchAngle: String
}

struct solveModel: Decodable {
    let matchArray: Array<matchModel>
    let matchArrayReduced: Array<matchModel>?
}
