//
//  LevelSelectScene.swift
//  Match Out
//
//  Created by Леванов Алексей on 05.02.2023.
//

import Foundation
import SpriteKit
import GameplayKit


class LevelSelectScene: SKScene {

    var backgroundImage: SKSpriteNode = SKSpriteNode()
    var scrollView: SwiftySKScrollView?
    let moveableNode = SKNode()
    var levelModel: LevelModel?
    var gameService: GameService?
    
    override func didMove(to view: SKView) {
        // TODO проверяем текущий уровень
        // Парсим уровень
        // Собираем уровень, исходя из ThemeModel
        
        // TODO первый шаг - проверяем как отображается спичка +
        // Второй шаг - поправить уровень в JSON на основе собранного кода -
        // Третий шаг - парсим уровень
        self.gameService = GameService()
        prepareLevel()
        
        self.addChild(moveableNode)
        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), moveableNode: moveableNode, direction: .horizontal)
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width * 3, height: scrollView!.frame.height) // * Делаем на два блока выборов
        view.addSubview(scrollView!)
        scrollView?.setContentOffset(CGPoint(x: 0 + 2 * scrollView!.frame.width , y: 0), animated: false)
        scrollView?.isPagingEnabled = true
        
        prepareButtons()
        prepareMainMenu()
    }
    
    func prepareLevel() {
        self.levelModel = LevelParser().loadLevel(levelName: gameService?.getUserLevel() ?? "level_1")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            // Устанавливаем background
            backgroundImage = themeLevel.backgroundLevelSprite
            backgroundImage.size.height = self.frame.height
            backgroundImage.zPosition = -5
            self.addChild(backgroundImage)
            startEndlessAnimation()
        }
    }
    
    func prepareMainMenu() {
        self.levelModel = LevelParser().loadLevel(levelName: gameService?.getUserLevel() ?? "level_1")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            let yPosition = -(self.view?.frame.size.height)!/2
            let titleLabel = SKAdvancedLabelNode.init(text: "CHOOSE  LEVEL")//.localized())
            titleLabel.position = CGPoint.init(x: 0, y: -yPosition - safeAreaInsets().top + 120)
            titleLabel.fontColor = themeLevel.textColor
            titleLabel.fontSize = 70
            titleLabel.fontName = "HelveticaNeue-Medium"
            titleLabel.shake(delay: 0.3)
            self.addChild(titleLabel)
        
            let cancelButton = MenuButton.init(size: .small, title: "Cancel", type: themeLevel)
            cancelButton.zPosition = 1
            cancelButton.name = "Cancel"
            cancelButton.position =  CGPoint.init(x: 0, y: yPosition - safeAreaInsets().bottom - 50)
            self.addChild(cancelButton)
        }
//        let cancelButton = MainMenuButton.init(buttonTitle: "CANCEL")//.localized())
//        cancelButton.position = CGPoint.init(x: 0, y: yPosition - cancelButton.frame.size.height)
//        cancelButton.isUserInteractionEnabled = true
//        cancelButton.selectedHandler = {
//            let scene = GameScene(fileNamed: "GameScene")!
//            scene.scaleMode = SKSceneScaleMode.aspectFill
//            let transition = SKTransition.doorsOpenVertical(withDuration: 0.7)
//            self.view?.presentScene(scene, transition: transition)
//        }
//        self.addChild(cancelButton)
    }
    
    func prepareButtons() {
        guard let scrollView = scrollView else { return }

        let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page1ScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width * 2), y: frame.midY)//CGPoint(x: frame.midX - (scrollView.frame.width * 2), y: frame.midY)
        moveableNode.addChild(page1ScrollView)
                
        let page2ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page2ScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width * 1), y: frame.midY)
        page2ScrollView.zPosition = -1
        moveableNode.addChild(page2ScrollView)
            
        let page3ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
        page3ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
//        page3ScrollView.zPosition = 1
        moveableNode.addChild(page3ScrollView)

        let currentUserLevel = self.gameService?.getUserLevelNumber() ?? 0
        let maxUserLevel = self.gameService?.getUserMaxLevelNumber() ?? 0
        /// Test sprites page 1
        self.levelModel = LevelParser().loadLevel(levelName: gameService?.getUserLevel() ?? "level_1")
        if let themeLevel = ThemeService.backgroundColorForLevelType(levelType: self.levelModel?.levelType) {
            let halfWidth = (self.view?.frame.size.width)!/2
            let offset = (halfWidth - chooseButtonSize) / 1
            let totalNumberOfLevels = 24
    //
            let iCounter: Int = Int(totalNumberOfLevels/3) // Сколько рядов по 3
            let jCounter: Int = 2 // Сколько в ряду - 3, от 0 до 2
            let baseYOffset: CGFloat = scrollView.frame.size.height/2 - 350
            var levelCounter = 1
            for i in 0...min(iCounter, 3) {
                let y = baseYOffset - CGFloat(i) * (chooseButtonSize + 100)
                for j in 0...jCounter {
                    var isButtonEnabled = true
    //                // Если уровень еще не доступен
                    if levelCounter > maxUserLevel {
                        isButtonEnabled = false
                    }
                    var isLevelSelected = false
                    if levelCounter == currentUserLevel {
                        isLevelSelected = true
                    }
                    let levelButton = ChooseLevelButtonNode.init(buttonTitle: String(levelCounter), isEnabled: isButtonEnabled, textColor: themeLevel.textColor, isSelected: isLevelSelected, matchType: themeLevel.matchType)
                    levelButton.isUserInteractionEnabled = isButtonEnabled
                    levelButton.position = CGPoint(x: -halfWidth + CGFloat(j) * (offset + chooseButtonSize), y: y)
                    levelButton.levelToSelect = levelCounter
                    levelButton.selectedHandler = {
                        for view in self.view!.subviews {
                            view.removeFromSuperview()
                        }
                        self.gameService?.setUserLevel(level: levelButton.levelToSelect)
                        let scene = GameScene(fileNamed: "GameScene")!
                        scene.scaleMode = SKSceneScaleMode.aspectFill
                        if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {
                            let transition = SKTransition(ciFilter: filter, duration: 0.5)
                            self.view?.presentScene(scene, transition: transition)
                        }
                    }
                    page1ScrollView.addChild(levelButton)
                    levelCounter+=1
                }
            }

        for i in 0...min(iCounter-5, 5) {
            let y = baseYOffset - CGFloat(i) * (chooseButtonSize + 100)
            for j in 0...jCounter {
                var isButtonEnabled = true
//                // Если уровень еще не доступен
                if levelCounter > maxUserLevel {
                    isButtonEnabled = false
                }
                var isLevelSelected = false
                if levelCounter == currentUserLevel {
                    isLevelSelected = true
                }
                let levelButton = ChooseLevelButtonNode.init(buttonTitle: String(levelCounter), isEnabled: isButtonEnabled, textColor: themeLevel.textColor, isSelected: isLevelSelected, matchType: themeLevel.matchType)
                levelButton.isUserInteractionEnabled = isButtonEnabled
                levelButton.position = CGPoint(x: -halfWidth + CGFloat(j) * (offset + chooseButtonSize), y: y)
                levelButton.levelToSelect = levelCounter
                levelButton.selectedHandler = {
                    for view in self.view!.subviews {
                        view.removeFromSuperview()
                    }
                    self.gameService?.setUserLevel(level: levelButton.levelToSelect)
                    let scene = GameScene(fileNamed: "GameScene")!
                    scene.scaleMode = SKSceneScaleMode.aspectFill
                    if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {
                        let transition = SKTransition(ciFilter: filter, duration: 0.5)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
                page2ScrollView.addChild(levelButton)
                levelCounter+=1
            }
        }
        
//
            let moreLevelsAreComming = SKLabelNode.init(text: "More challenging levels")//.localized())
            moreLevelsAreComming.numberOfLines = 1
            moreLevelsAreComming.position = CGPoint.init(x: 0, y: 50)
            moreLevelsAreComming.fontSize = 45
            moreLevelsAreComming.verticalAlignmentMode = .center
            moreLevelsAreComming.horizontalAlignmentMode = .center
            moreLevelsAreComming.fontName = "HelveticaNeue-Medium"
            moreLevelsAreComming.fontColor = themeLevel.textColor
    //        moreLevelsAreComming.shake(delay: 0, infinite: true, duration: 5, amplitudeX: 5, amplitudeY: 10, speed: 0.25)
            page3ScrollView.addChild(moreLevelsAreComming)

            let animatedLabel = SKAdvancedLabelNode.init(text: "are coming soon !")//.localized())
            animatedLabel.position = CGPoint.init(x: 0, y: moreLevelsAreComming.frame.minY - 70)
            animatedLabel.fontSize = 50
    //        animatedLabel.verticalAlignmentMode = .center
            animatedLabel.horizontalAlignmentMode = .center
            animatedLabel.fontName = "HelveticaNeue-Medium"
            animatedLabel.fontColor = themeLevel.textColor
            animatedLabel.shake(delay: 0.2)
            page3ScrollView.addChild(animatedLabel)
        }
    }
    
    func startEndlessAnimation() {
        let moveLeft = SKAction.moveBy(x: 800, y: 0, duration: 23)
        let moveReset = SKAction.moveBy(x: -800, y: 0, duration: 23)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        backgroundImage.run(moveForever)
    }
    
    private func safeAreaInsets() -> UIEdgeInsets {
         if #available(iOS 11.0, *) {
             return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
         } else {
             return .zero
         }
     }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "Cancel" {
                    for view in self.view!.subviews {
                        view.removeFromSuperview()
                    }
                    let scene = MenuScene(fileNamed: "MenuScene")!
                    scene.scaleMode = SKSceneScaleMode.aspectFill
                    if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {
                        let transition = SKTransition(ciFilter: filter, duration: 0.5)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
            }
        }
    }
}
