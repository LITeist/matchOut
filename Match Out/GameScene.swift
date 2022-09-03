//
//  GameScene.swift
//  Match Out
//
//  Created by Леванов Алексей on 18.08.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var backgroundImage: SKSpriteNode = SKSpriteNode()
    var descriptionLabel: SKLabelNode = SKLabelNode()
    var bulbButtonNode: SKSpriteNode = SKSpriteNode()
    var menuButtonNode: SKSpriteNode = SKSpriteNode()
    var levelModel: LevelModel?
    
    override func didMove(to view: SKView) {
        // TODO проверяем текущий уровень
        // Парсим уровень
        // Собираем уровень, исходя из ThemeModel
        
        // TODO первый шаг - проверяем как отображается спичка +
        // Второй шаг - поправить уровень в JSON на основе собранного кода -
        // Третий шаг - парсим уровень
        self.levelModel = LevelParser().loadLevel(levelName: "level_3")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            // Устанавливаем background
            backgroundImage = themeLevel.backgroundLevelSprite
            backgroundImage.size.height = self.frame.height
            backgroundImage.zPosition = -5
            self.addChild(backgroundImage)
            // Устанавливаем текст
            descriptionLabel.fontName = "HelveticaNeue-Medium"
            descriptionLabel.fontSize = 43.0
            descriptionLabel.fontColor = themeLevel.textColor
            descriptionLabel.text = self.levelModel?.description
            descriptionLabel.position = CGPoint.init(x: 20, y: 320)
            descriptionLabel.numberOfLines = 3
            descriptionLabel.horizontalAlignmentMode = .center
            self.addChild(descriptionLabel)
            // Устанавливаем кнопки
            bulbButtonNode = SKSpriteNode.init(imageNamed: "bulb")
            bulbButtonNode.position = CGPoint.init(x: -250, y: 560)
            bulbButtonNode.size = CGSize.init(width: 90, height: 90)
            bulbButtonNode.color = themeLevel.buttonsTintColor
            bulbButtonNode.colorBlendFactor = 1
            self.addChild(bulbButtonNode)
            menuButtonNode = SKSpriteNode.init(imageNamed: "menuBlue")
            menuButtonNode.position = CGPoint.init(x: 227, y: 560)
            menuButtonNode.size = CGSize.init(width: 80, height: 80)
            menuButtonNode.color = themeLevel.buttonsTintColor
            menuButtonNode.colorBlendFactor = 1
            self.addChild(menuButtonNode)
            // Запускаем анимацию заднего фона
            startEndlessAnimation()
            // Устанавливаем спички
            if let matches = self.levelModel?.matches {
                for match in matches {
                    let matchNode = MatchNode.init(type: themeLevel.matchType, matchSize: self.levelModel?.matchSize ?? .small, isPotentialMatch: match.matchType == 0)
                    matchNode.position = CGPoint.init(x: CGFloat(match.x), y: CGFloat(match.y))
                    matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: match.matchAngle)
                    // Если matchType 0 - помещаем там placeholder спички
                    if match.matchType == 0 {
                        matchNode.alpha = 0.15
                    } else {
                        // Иначе добавляем там еще настоящую спичку
                        let placeHolderMatchNode = MatchNode.init(type: themeLevel.matchType, matchSize: self.levelModel?.matchSize ?? .small, isPotentialMatch: true)
                        placeHolderMatchNode.position = CGPoint.init(x: CGFloat(match.x), y: CGFloat(match.y))
                        placeHolderMatchNode.zRotation = matchNode.floatAngleFromString(stringAngle: match.matchAngle)
                        placeHolderMatchNode.alpha = 0.15
                        placeHolderMatchNode.zPosition = -1
                        self.addChild(placeHolderMatchNode)
                    }
                    self.addChild(matchNode)
                }
            }
            // Указываем количество доступных спичек
            for i in 0..<abs(self.levelModel?.extraMatches ?? 0) {
                // Если extraMatch отрицательный - спички можно только возвращать с доски и показываем ghostMatch
                // TODO доработать ghostMatch, пока Black
                var matchType: MatchType = .black
                if self.levelModel?.extraMatches ?? 0 > 0 {
                    matchType = themeLevel.matchType
                }
                let matchNode = MatchNode.init(type: matchType, matchSize: self.levelModel?.matchSize ?? .small)
                matchNode.position = CGPoint.init(x: CGFloat(-280 + i*40), y: self.frame.minY + 20)
                self.addChild(matchNode)
            }
        }
    }
    
    func startEndlessAnimation() {
        let moveLeft = SKAction.moveBy(x: 800, y: 0, duration: 23)
        let moveReset = SKAction.moveBy(x: -800, y: 0, duration: 23)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        backgroundImage.run(moveForever)
    }
}
