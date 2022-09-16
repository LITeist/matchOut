//
//  MenuScene.swift
//  Match Out
//
//  Created by Леванов Алексей on 15.09.2022.
//

import SpriteKit
import GameplayKit
import CryptoKit

class MenuScene: SKScene {
    
    var backgroundImage: SKSpriteNode = SKSpriteNode()
//    var descriptionLabel: SKLabelNode = SKLabelNode()
//    var bulbButtonNode: SKSpriteNode = SKSpriteNode()
//    var menuButtonNode: SKSpriteNode = SKSpriteNode()
    var levelModel: LevelModel?
    var gameService: GameService?
    
    override func didMove(to view: SKView) {

        self.gameService = GameService()
        // TODO тут загружать последний актуальный уровень
        self.levelModel = LevelParser().loadLevel(levelName: "level_7")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            // Устанавливаем background
            backgroundImage = themeLevel.backgroundLevelSprite
            backgroundImage.size.height = self.frame.height
            backgroundImage.zPosition = -5
            self.addChild(backgroundImage)
            // Запускаем анимацию заднего фона
            startEndlessAnimation()
            // И анимацию спичек
            startMatchAnimation()
            // Вот тут расставляем элементы управления. В нашем кейсе - запускаем спички
            let menuButton = MenuButton.init(size: .medium, title: "Start Game", type: themeLevel.matchType)
            menuButton.zPosition = 1
            menuButton.position = CGPoint.init(x: 0, y: 1200)
            self.addChild(menuButton)
            
            let moveAction = SKAction.moveTo(y: 90, duration: 2.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5)
            menuButton.run(moveAction)
        }
    }
    
    func startEndlessAnimation() {
        let moveLeft = SKAction.moveBy(x: 800, y: 0, duration: 23)
        let moveReset = SKAction.moveBy(x: -800, y: 0, duration: 23)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        backgroundImage.run(moveForever)
    }
    
    // Пока совсем плохо, нужно больше 'случайности'
    func startMatchAnimation() {
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            var matchFigureTypes: [String] = []
            for _ in 0...5 {
                var matchTest: MatchForm = FormGenerator.generateRandomMatchForm(type: themeLevel.matchType)
                while matchFigureTypes.contains(matchTest.name!) {
                    matchTest = FormGenerator.generateRandomMatchForm(type: themeLevel.matchType)
                }
                matchFigureTypes.append(matchTest.name!)
                matchTest.position = randomPosition()
                matchTest.alpha = 0.6
                matchTest.zPosition = 1
                self.addChild(matchTest)
                 
                animateMoveForMatch(matchToAnimate: matchTest)
            }
        }
    }
    
    func animateMoveForMatch(matchToAnimate: MatchForm) {
        matchToAnimate.position = randomPosition()
        matchToAnimate.zRotation = MatchNode().floatAngleFromString(stringAngle: randomAngleString())
        let xMove = CGFloat(matchToAnimate.position.x > 0 ? -abs(getRandomXPositionForMatchForm())*2 : abs(getRandomXPositionForMatchForm())*2)
        let yMove = CGFloat(Float.random(in: -1200 ..< -800))
//CGFloat(matchToAnimate.position.y > 0 ? -abs(getRandomYPositionForMatchForm())*2 : abs(getRandomYPositionForMatchForm())*2)
        let xMoveBack = CGFloat(matchToAnimate.position.x > 0 ? abs(getRandomXPositionForMatchForm())*2 : -abs(getRandomXPositionForMatchForm())*2)
        
        let randomDelay = CGFloat(Int.random(in: 0..<10))
        print(randomDelay)
        let moveDelay = SKAction.wait(forDuration: randomDelay)
        let moveAction = SKAction.moveBy(x: xMove, y: yMove, duration: getRandomDuration())
        let moveBack = SKAction.moveBy(x: xMoveBack, y: -yMove, duration: getRandomDuration())
        let rotateAction = SKAction.rotate(toAngle: -matchToAnimate.zRotation, duration: moveAction.duration)
        let moveLoop = SKAction.sequence([moveAction, moveBack])
//        matchToAnimate.run(moveDelay) {
            matchToAnimate.run(rotateAction)
            matchToAnimate.run(moveLoop) {
                self.animateMoveForMatch(matchToAnimate: matchToAnimate)
            }
//        }
    }
    
    func randomPosition()->CGPoint {
        return CGPoint.init(x: getRandomXPositionForMatchForm(), y: getRandomYPositionForMatchForm())
    }
    
    func getRandomDuration()->CGFloat {
        return CGFloat(Int.random(in: 10..<55))
    }
    
    func getRandomXPositionForMatchForm()->CGFloat {
        let randomValue = Int.random(in: 0..<2)
        if randomValue == 0{
            return CGFloat(Float.random(in: -1200 ..< -800))
        } else {
            return CGFloat(Float.random(in: 800..<1200))
        }
    }
    
    func getRandomYPositionForMatchForm()->CGFloat {
        // От 1600 до 1000
        return CGFloat(Float.random(in: 800..<1200))
//        let randomValue = Int.random(in: 0..<2)
//        if randomValue == 0{
//            return CGFloat(Float.random(in: -1200 ..< -800))
//        } else {
//            return CGFloat(Float.random(in: 800..<1200))
//        }
    }
    
    func randomAngleString()->String {
        let randomValue = Int.random(in: 0..<10)
        switch randomValue {
        case 0:
            return "-.pi"
        case 1:
            return ".pi"
        case 2:
            return ".-pi/2"
        case 3:
            return ".pi/2"
        case 4:
            return ".pi/3"
        case 5:
            return "-.pi/3"
        case 6:
            return ".pi/4"
        case 7:
            return ".-pi/4"
        case 8:
            return ".pi/6"
        case 9:
            return "-.pi/6"
        default:
            return "-.pi/6"
        }
    }
}
