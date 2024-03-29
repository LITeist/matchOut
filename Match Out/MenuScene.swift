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
    var settingsButton: SKSpriteNode = SKSpriteNode()
    let gameScene = GameScene(fileNamed: "GameScene")!
    
    override func didMove(to view: SKView) {

        self.gameService = GameService()
        // TODO тут загружать последний актуальный уровень
        self.levelModel = LevelParser().loadLevel(levelName: gameService?.getUserLevel() ?? "level_1")
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
            // TODO проверяем вращение для кнопки 'Настройки'
            settingsButton = SKSpriteNode.init(imageNamed: ThemeService.settingsImageName(levelType: self.levelModel?.levelType))
            settingsButton.size = CGSize.init(width: 100, height: 100)
            settingsButton.position = CGPoint.init(x: -190, y: -562)
            settingsButton.colorBlendFactor = 0.4
            settingsButton.color = globalBlueColor
            settingsButton.name = "settings"
            self.addChild(settingsButton)
            
            // Кнопка выбора уровней
            let levelSelectButton = SKSpriteNode.init(imageNamed: ThemeService.mainMenuMenuImageName(levelType: self.levelModel?.levelType))
            levelSelectButton.size = CGSize.init(width: 100, height: 100)
            levelSelectButton.position = CGPoint.init(x: 190, y: -562)
            levelSelectButton.colorBlendFactor = 0.4
            levelSelectButton.color = globalBlueColor
            levelSelectButton.name = "levelSelect"
            self.addChild(levelSelectButton)
            
            // Размещаем монетки и сумму, для теста. Анимируем монетки
            let currentMoney = SKSpriteNode.init(imageNamed: "Gold_21")
            currentMoney.size = CGSize.init(width: 50, height: 50)
            currentMoney.position = CGPoint.init(x: 135, y: 575)
            self.addChild(currentMoney)
            let moneyLabel = SKLabelNode.init(text: "2000")
            moneyLabel.fontSize = 50
            moneyLabel.fontName = "HelveticaNeue-Medium"
            moneyLabel.position = CGPoint.init(x: 226, y: 556)
            moneyLabel.fontColor = globalBlueColor
            self.addChild(moneyLabel)
            self.animateMoneySprite(moneySprite: currentMoney)
            
            // Размещаем главные кнопки
            let menuButton = MenuButton.init(size: .medium, title: "Start  Game", type: themeLevel)
            menuButton.zPosition = 1
            menuButton.position = CGPoint.init(x: 0, y: 1200)
            menuButton.name = "StartGame"
            self.addChild(menuButton)
            
            let adsButton = MenuButton.init(size: .small, title: "", type: themeLevel)
            adsButton.zPosition = 1
            adsButton.position =  CGPoint.init(x: 0, y: 1100)
            self.addChild(adsButton)
            
            // TODO тут выбирать иконку другую
            let presentIcon = SKSpriteNode.init(imageNamed: ThemeService.presentImageName(levelType: self.levelModel?.levelType))
            presentIcon.zPosition = 2
            presentIcon.size = CGSize.init(width: 90, height: 90)
            adsButton.addChild(presentIcon)
            // Делаем анимацию прыжков подарка
            let rotateAction = SKAction.rotate(byAngle: .pi/40, duration: 0.05)
            let jumpActionUp = SKAction.moveBy(x: -1, y: 1, duration: 0.1)
            let jumpActionDown = SKAction.moveBy(x: 1, y: -1, duration: 0.1)
            let rotateActionBack = SKAction.rotate(byAngle: -.pi/40, duration: 0.05)
            let wait = SKAction.wait(forDuration: 0.1)
            //
            let rotateActionRight = SKAction.rotate(byAngle: -.pi/40, duration: 0.05)
            let jumpActionUpRight = SKAction.moveBy(x: 1, y: 1, duration: 0.1)
            let jumpActionDownRight = SKAction.moveBy(x: -1, y: -1, duration: 0.1)
            let rotateActionBackRight = SKAction.rotate(byAngle: .pi/40, duration: 0.05)
            // Анимируем подарок
            let moveLoop = SKAction.sequence([rotateAction, jumpActionUp, jumpActionDown, rotateActionBack, wait, rotateActionRight, jumpActionUpRight, jumpActionDownRight, rotateActionBackRight, wait])
            let moveForever = SKAction.repeatForever(moveLoop)
            presentIcon.run(moveForever)
            
            let moveAction = SKAction.moveTo(y: 100, duration: 2.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5)
            let adsMoveAction = SKAction.moveTo(y: -120, duration: 2.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6)
            menuButton.run(moveAction) {
                menuButton.startAnimation()
            }
            adsButton.run(adsMoveAction)
        }
    }
    
    func animateMoneySprite(moneySprite: SKSpriteNode) {
        let moneyAnimation = SKAction.scale(to: 1.05, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        let moneyBackAnimation = SKAction.scale(to: 1, duration: 3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        moneySprite.run(moneyAnimation) {
            moneySprite.run(moneyBackAnimation) {
                self.animateMoneySprite(moneySprite: moneySprite)
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
    
    func startGame() {
        // Мерцает
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {//["inputCenter":CIVector(x: -500, y: 900)]) {
            let transition = SKTransition(ciFilter: filter, duration: 0.5)
            //
    //        let transition = SKTransition.crossFade(withDuration: 0.8)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // При нажатии на 'настройки' временно увеличиваем ей zPosition, вращаем, затемняем весь экран и выводим элементы настроек (spring со scale)
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "StartGame" {
                    startGame()
                }  else if node.name == "settings" {
                    if let backgroundNode = self.childNode(withName: "settingsBackground") as? SKSpriteNode {
                        let fadeAnimation = SKAction.fadeAlpha(to: 0, duration: 0.75)
                        backgroundNode.run(fadeAnimation) {
                            backgroundNode.removeFromParent()
                        }
                    } else  {
                        let shapeBackgroundNode = SKSpriteNode.init(color: .black, size: self.size)
                        shapeBackgroundNode.alpha = 0.0
                        shapeBackgroundNode.zPosition = 50
                        shapeBackgroundNode.name = "settingsBackground"
                        settingsButton.zPosition = 51
                        self.addChild(shapeBackgroundNode)
                        
                        let fadeAnimation = SKAction.fadeAlpha(to: 0.95, duration: 0.75)
                        shapeBackgroundNode.run(fadeAnimation) {
                            self.presentSettings(parentNode: shapeBackgroundNode)
                        }
                    }

                    let rotateAction = SKAction.rotate(byAngle: MatchNode().floatAngleFromString(stringAngle: ".pi"), duration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5)
                    settingsButton.run(rotateAction)
                    return()
                }
                else if node.name == "levelSelect" {
                    let levelSelectScene = LevelSelectScene(fileNamed: "LevelSelectScene")!
                    levelSelectScene.scaleMode = SKSceneScaleMode.aspectFill
                    for view in self.view!.subviews {
                        view.removeFromSuperview()
                    }
                    if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {
                        let transition = SKTransition(ciFilter: filter, duration: 0.5)
                        self.view?.presentScene(levelSelectScene, transition: transition)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
    }
    
    func presentSettings(parentNode: SKSpriteNode) {
        
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {

            let musicLabel = SKLabelNode.init(text: "Music:")
            musicLabel.fontName = "HelveticaNeue-Bold"
            musicLabel.fontSize = 58
            musicLabel.fontColor = UIColor.white
            musicLabel.position = CGPoint.init(x: -150, y: 350)
            musicLabel.horizontalAlignmentMode = .center
            musicLabel.verticalAlignmentMode = .center
            parentNode.addChild(musicLabel)
            
            let chooseOffMusic = ChooseLevelButtonNode.init(buttonTitle: "Off", isEnabled: true, textColor: .white, isSelected: true, matchType: themeLevel.matchType)
            chooseOffMusic.position = CGPoint.init(x: 70, y: 350)
            parentNode.addChild(chooseOffMusic)
            
            let chooseOnfMusic = ChooseLevelButtonNode.init(buttonTitle: "On", isEnabled: false, textColor: .white, isSelected: false, matchType: themeLevel.matchType)
            chooseOnfMusic.position = CGPoint.init(x: 200, y: 350)
            parentNode.addChild(chooseOnfMusic)
            
            let soundLabel = SKLabelNode.init(text: "Sound:")
            soundLabel.fontName = "HelveticaNeue-Bold"
            soundLabel.fontSize = 58
            soundLabel.fontColor = UIColor.white
            soundLabel.position = CGPoint.init(x: -150, y: 100)
            soundLabel.horizontalAlignmentMode = .center
            soundLabel.verticalAlignmentMode = .center
            parentNode.addChild(soundLabel)
            
            let chooseOffSound = ChooseLevelButtonNode.init(buttonTitle: "Off", isEnabled: false, textColor: .white, isSelected: false, matchType: themeLevel.matchType)
            chooseOffSound.position = CGPoint.init(x: 70, y: 100)
            parentNode.addChild(chooseOffSound)
            
            let chooseOnSound = ChooseLevelButtonNode.init(buttonTitle: "On", isEnabled: true, textColor: .white, isSelected: true, matchType: themeLevel.matchType)
            chooseOnSound.position = CGPoint.init(x: 200, y: 100)
            parentNode.addChild(chooseOnSound)
            
            let restorePurchaseButton = MenuButton.init(size: .medium, title: "Restore purchase", type: ThemeModel.init(textColor: UIColor.white, buttonsTintColor: UIColor.white, backgroundLevelSprite: SKSpriteNode(), matchType: themeLevel.matchType))
            restorePurchaseButton.position = CGPoint.init(x: 0, y: -300)
            restorePurchaseButton.fontSize = 50
            parentNode.addChild(restorePurchaseButton)
        }
    }
}
