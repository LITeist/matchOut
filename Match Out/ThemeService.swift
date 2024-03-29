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
let globalYellowColor: UIColor = UIColor.init(red: 243/255.0, green: 216/255.0, blue: 130/255.0, alpha: 1)


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
        
    static func reloadImageName(levelType: LevelColorType?)->String {
        switch levelType {
        case .green:
            return "reloadBlue"
        case .gray:
            return "reloadBlack"
        case .pink:
            return "reloadBrown"
        case .purple:
            return "reloadYellow"
        default:
            return "reloadBlue"
        }
    }
    
    static func presentImageName(levelType: LevelColorType?)->String {
        switch levelType {
        case .purple:
            return "presentYellow"
        case .gray:
            return "presentBlack"
        case .pink:
            return "presentBrown"
        default:
            return "presentBlue"
        }
    }
    
    static func settingsImageName(levelType: LevelColorType?)->String {
        switch levelType {
        case .purple:
            return "settingsYellow"
        case .gray:
            return "settingsBlack"
        case .pink:
            return "settingsBrown"
        default:
            return "settingsBlue"
        }
    }
    
    static func menuImageName(levelType: LevelColorType?)->String {
        switch levelType {
        case .purple:
            return "brightYellowMenu"
        case .gray:
            return "menuBlack"
        case .pink:
            return "menuBrown"
        default:
            return "menuBlue"
        }
    }
    
    static func mainMenuMenuImageName(levelType: LevelColorType?)->String {
        switch levelType {
        case .purple:
            return "menuYellow"
        case .gray:
            return "menuBlack"
        case .pink:
            return "menuBrown"
        default:
            return "menuBlue"
        }
    }
}
