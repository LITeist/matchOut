//
//  ThemeService.swift
//  Match Out
//
//  Created by Леванов Алексей on 24.08.2022.
//

import Foundation
import SpriteKit

// Константные цвета
let globalBlueColor: UIColor = UIColor.init(red: 84/255.0, green: 114/255.0, blue: 184/255.0, alpha: 1)
let globalGreenColor: UIColor = UIColor.init(red: 116/255.0, green: 178/255.0, blue: 85/255.0, alpha: 1)
let globalBlackColor: UIColor = UIColor.init(red: 63/255.0, green: 63/255.0, blue: 63/255.0, alpha: 1)
let globalBrownColor: UIColor = UIColor.init(red: 96/255.0, green: 79/255.0, blue: 55/255.0, alpha: 1)
let globalPurpleColor: UIColor = UIColor.init(red: 96/255.0, green: 64/255.0, blue: 176/255.0, alpha: 1)
let globalYellowColor: UIColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 0, alpha: 1)


/// Модель темы для уровня, содержит цвет фона, цвет спичек, цвет текста задания
struct ThemeModel {
    let textColor: UIColor // Цвет задания
    let buttonsTintColor: UIColor // Цвет для кнопок
    let backgroundLevelSprite: SKSpriteNode // Спрайт для бэкграунда
    let matchType: MatchType
}

class ThemeService {
    static func backgroundColorForLevelType(levelType: LevelColorType?)->ThemeModel? {
        switch levelType {
        case .green:
            return ThemeModel(textColor: globalBlueColor, buttonsTintColor: globalBlueColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundWhiteGreen"), matchType: .blue)
        case .red:
            return ThemeModel(textColor: globalBlueColor, buttonsTintColor: globalBlueColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundWhiteAndRed"), matchType: .blue)
        case .orange:
            return ThemeModel(textColor: globalBlueColor, buttonsTintColor: globalBlueColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundWhiteOrange"), matchType: .blue)
        case .gray:
            return ThemeModel(textColor: globalBlackColor, buttonsTintColor: globalBlackColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundWhiteAndGray"), matchType: .black)
        case .pink:
            return ThemeModel(textColor: globalBlackColor, buttonsTintColor: globalBlackColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundWhitePink"), matchType: .brown)
        case .purple:
            return ThemeModel(textColor: globalYellowColor, buttonsTintColor: globalYellowColor, backgroundLevelSprite: SKSpriteNode.init(imageNamed: "backgroundPurple"), matchType: .red)
        case .none:
            return nil
        }
    }
    
    static func bulbImageName(levelType: LevelColorType?)->String {
        if levelType == .purple {
            return "yellowBulb"
        }
        return "bulb"
    }
    
    static func menuImageName(levelType: LevelColorType?)->String {
        if levelType == .purple {
            return "yellowMenu"
        }
        return "menu"
    }

}
