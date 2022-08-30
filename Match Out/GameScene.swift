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
    var levelModel: LevelModel?
    
    override func didMove(to view: SKView) {
        // TODO проверяем текущий уровень
        // Парсим уровень
        // Собираем уровень, исходя из ThemeModel
        
        // TODO первый шаг - проверяем как отображается спичка +
        // Второй шаг - поправить уровень в JSON на основе собранного кода -
        // Третий шаг - парсим уровень
//        let matchNode = MatchNode.init(type: .green)
//        matchNode.position = CGPoint.zero
//        self.addChild(matchNode)
//
//        let moreMatchNode = MatchNode.init(type: .brown)
//        moreMatchNode.position = CGPoint.init(x: 72, y: 75)
//        moreMatchNode.zRotation = .pi / 2
//        self.addChild(moreMatchNode)
//
//        let redMatch = MatchNode.init(type: .red)
//        redMatch.position = CGPoint.init(x: 150, y: 0)
//        redMatch.zRotation = .pi
//        self.addChild(redMatch)
//
//        let blueMatch = MatchNode.init(type: .blue)
//        blueMatch.position = CGPoint.init(x: 75, y: -75)
//        blueMatch.zRotation = -.pi/2
//        self.addChild(blueMatch)
//
        self.levelModel = LevelParser().loadLevel(levelName: "testLevel")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            backgroundImage = themeLevel.backgroundLevelSprite
            backgroundImage.size.height = self.frame.height
            backgroundImage.zPosition = -5
            self.addChild(backgroundImage)
            if let matches = self.levelModel?.matches {
                for match in matches {
                    let matchNode = MatchNode.init(type: themeLevel.matchType)
                    matchNode.position = CGPoint.init(x: CGFloat(match.x), y: CGFloat(match.y))
                    matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: match.matchAngle)
                    self.addChild(matchNode)
                }
            }
        }
//        let blackMatch = MatchNode.init(type: .black)
//        blackMatch.position = CGPoint.init(x: 75, y: 0)
////        blackMatch.zRotation =
//        self.addChild(blackMatch)
    }
    
}
