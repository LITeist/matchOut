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
    var gameService: GameService?
    var isLevelFinished: Bool = false
    
    override func didMove(to view: SKView) {
        // TODO проверяем текущий уровень
        // Парсим уровень
        // Собираем уровень, исходя из ThemeModel
        
        // TODO первый шаг - проверяем как отображается спичка +
        // Второй шаг - поправить уровень в JSON на основе собранного кода -
        // Третий шаг - парсим уровень
        self.gameService = GameService()
        prepareLevel()
        self.removeConfetti()
    }
    
    func prepareLevel() {
        self.levelModel = LevelParser().loadLevel(levelName: gameService?.getUserLevel() ?? "level_1")
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
            descriptionLabel.zPosition = 2
            if self.levelModel?.levelType == .purple {
                let backgroundTextView = SKSpriteNode.init(color: globalPurpleColor, size: CGSize.init(width: 800, height: 500))
                backgroundTextView.position = CGPoint.init(x: 0, y: 550)
                backgroundTextView.zPosition = 1
                self.addChild(backgroundTextView)
            }
            descriptionLabel.position = CGPoint.init(x: 20, y: 320)
            descriptionLabel.numberOfLines = 3
            descriptionLabel.horizontalAlignmentMode = .center
            self.addChild(descriptionLabel)
            // Устанавливаем кнопки
            bulbButtonNode = SKSpriteNode.init(imageNamed: ThemeService.bulbImageName(levelType: self.levelModel?.levelType ?? .green))
            bulbButtonNode.position = CGPoint.init(x: -250, y: 560)
            bulbButtonNode.size = CGSize.init(width: 90, height: 90)
            bulbButtonNode.color = themeLevel.buttonsTintColor
            bulbButtonNode.colorBlendFactor = 1
            bulbButtonNode.zPosition = 3
            self.addChild(bulbButtonNode)
            menuButtonNode = SKSpriteNode.init(imageNamed: ThemeService.menuImageName(levelType: self.levelModel?.levelType ?? .green))
            menuButtonNode.position = CGPoint.init(x: 227, y: 560)
            menuButtonNode.size = CGSize.init(width: 80, height: 80)
            menuButtonNode.color = themeLevel.buttonsTintColor
            menuButtonNode.colorBlendFactor = 1
            menuButtonNode.zPosition = 3
            menuButtonNode.name = "menuButton"
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
                    matchNode.zPosition = matchNode.potentailMatch ? -1 : 0
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
            if self.levelModel?.extraMatches ?? 0 > 0 {
                for i in 0..<(self.levelModel?.extraMatches ?? 0) {
                    // Если extraMatch отрицательный - спички можно только возвращать с доски и показываем ghostMatch
                    // TODO доработать ghostMatch, пока Black
                    var matchType: MatchType = .black
                    if self.levelModel?.extraMatches ?? 0 > 0 {
                        matchType = themeLevel.matchType
                    }
                    let matchNode = MatchNode.init(type: matchType, matchSize: self.levelModel?.matchSize ?? .small)
                    matchNode.position = CGPoint.init(x: CGFloat(-280 + i*40), y: self.frame.minY + 20)
                    matchNode.name = "extraMatch"
                    self.addChild(matchNode)
                }
            }
            gameService?.extraNodesRemain = self.levelModel?.extraMatches ?? 0
        }
    }
    
    func startEndlessAnimation() {
        let moveLeft = SKAction.moveBy(x: 800, y: 0, duration: 23)
        let moveReset = SKAction.moveBy(x: -800, y: 0, duration: 23)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)

        backgroundImage.run(moveForever)
    }
    
    // Про движения
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Проверяем кнопки меню
        let touch = touches.first as UITouch?
        if let touchLocation = touch?.location(in: self) {
            if let targetNode = atPoint(touchLocation) as? SKSpriteNode {
                if targetNode.name == "menuButton" {
                    self.goToMenu()
                }
            }
        }
        // Проверяем, можно ли добавить или убрать спичку
        // Если можно убирать и спичка настоящая - убираем, иначе ничего не делаем
        // Если можно добавлять, есть спички и нажатая сейчас с спичка - плейсхолджер - переносим. Иначе ничего не делаем
        if let selectedMatchNode = getSelectedMatchFor(touches: touches) {
            switch levelModel?.gameplayType {
                case .add:
                    if selectedMatchNode.potentailMatch == true {
                        if let childNode = getExtraNodeForIndex(index: self.gameService?.extraNodesRemain ?? 0) {
                            childNode.zRotation = selectedMatchNode.zRotation
                            childNode.position = selectedMatchNode.position
                            childNode.canBecomeExtraMatch = true
                            self.gameService?.extraNodesRemain -= 1
                            impactOccured(intense: .light)
                        }
                    } else {
                        if selectedMatchNode.canBecomeExtraMatch {
                            moveNodeToExtraNodePlace(selectedMatchNode: selectedMatchNode)
                            impactOccured(intense: .light)
                        }
                }
                case .remove,
                    .move:
                    if selectedMatchNode.potentailMatch == false && selectedMatchNode.name != "extraMatch" {
                        //  Очень странная, но рабочая логика :)
                        if abs(gameService?.extraNodesRemain ?? 0) - abs(self.levelModel?.extraMatches ?? 0) < abs(self.levelModel?.extraMatches ?? 0)  {
                            moveNodeToExtraNodePlace(selectedMatchNode: selectedMatchNode, shouldIncrement: false)
                            impactOccured(intense: .light)
                        }
                    } else if selectedMatchNode.potentailMatch == true {
                        // Вынести в общий блог с параметром shouldIncrement
                        if let childNode = getExtraNodeForIndex(index: abs(self.gameService?.extraNodesRemain ?? 0)) {
                            childNode.zRotation = selectedMatchNode.zRotation
                            childNode.position = selectedMatchNode.position
                            childNode.canBecomeExtraMatch = true
                            childNode.name = ""
                            self.gameService?.extraNodesRemain += 1
                            impactOccured(intense: .light)
                        }
                    }
                case .none:
                    break
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO проверяем сходимость игры
        var isSuccess: Bool = false
        if let solvesArray = self.levelModel?.resolves {
            for solve in solvesArray {
                if isSucceedGameFinished(solve: solve) {
                    isSuccess = true
                }
            }
            if !isSuccess {
                return
            }
        }
        // Вот тут мы понимаем, что игра сошлась - надо бы еще пообрабатывать нажатия
        if !self.isLevelFinished {
            self.isLevelFinished = true
            showConfetti()
        } else  {
            let touch = touches.first as UITouch?
            if let touchLocation = touch?.location(in: self) {
                if let targetNode = atPoint(touchLocation) as? SKSpriteNode {
                    if targetNode.name == "next" {
                        // сначала убираем кнопки
                        // потом запускаем новый уровень
                        self.isLevelFinished = false
                        self.gameService?.incrementUserLevel()
                        self.removeMenuButtons()
                    }
                    else if targetNode.name == "reload" {
                        self.isLevelFinished = false
                        self.reloadLevel()
                    } else if targetNode.name == "menu" {
                        self.goToMenu()
                    }
                }
            }
        }
    }
    
    func reloadLevel() {
        self.removeMenuButtons()
    }
    
    func removeMenuButtons() {
        // Сначала убираем все Label
        for child in self.children {
            if child.isKind(of: SKLabelNode.self) {
                child.removeFromParent()
            }
        }
        // Потом анимации с кнопками
        if let menuButton = self.childNode(withName: "menu") {
            if let reloadButton = self.childNode(withName: "reload") {
                if let nextButton = self.childNode(withName: "next") {
                    let moveAction = SKAction.moveTo(y: 900, duration: 1.0, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3)
                    let smallMovesAction = SKAction.moveTo(y: 900, duration: 1.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3)
                    menuButton.run(smallMovesAction)
                    reloadButton.run(smallMovesAction)
                    nextButton.run(moveAction) {
                        self.removeConfetti()
                        self.removeAllChildren()
                        self.prepareLevel()
                    }
                }
            }
        }
    }
    
    func goToMenu() {
        let menuScene = MenuScene(fileNamed: "MenuScene")!
        menuScene.scaleMode = SKSceneScaleMode.aspectFill
        if let filter = CIFilter(name: "CIBarsSwipeTransition", parameters: nil) {
            let transition = SKTransition(ciFilter: filter, duration: 0.5)
            self.view?.presentScene(menuScene, transition: transition)
        }
    }
    
    func isSucceedGameFinished(solve: solveModel)->Bool {
        if self.levelModel?.gameplayType == .move {
            for matchModel in solve.matchArray {
                if checkIfMatchExistsOnBoard(matchToFind: matchModel) == false {
                    return false
                }
            }
            if let matchArrayReduces = solve.matchArrayReduced {
                for removedModel in matchArrayReduces {
                    if checkIfMatchNotExistsOnBoard(matchToFind: removedModel) == false {
                        return false
                    }
                }
            }
        } else {
            for matchModel in solve.matchArray {
                if self.levelModel?.gameplayType == .remove {
                    if checkIfMatchNotExistsOnBoard(matchToFind: matchModel) == false {
                        return false
                    }
                } else if self.levelModel?.gameplayType == .add {
                // Если не проходит проверка хоть раз - break цикла делаем
                    if checkIfMatchExistsOnBoard(matchToFind: matchModel) == false {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func checkIfMatchExistsOnBoard(matchToFind: matchModel)->Bool {
        for child in self.children {
            if let child = child as? MatchNode {
                if (abs(child.position.x - CGFloat(matchToFind.x)) < 0.1) && (abs(child.position.y - CGFloat(matchToFind.y)) < 0.1) && (!child.potentailMatch == Bool(truncating: matchToFind.matchType as NSNumber)) && (abs(child.floatAngleFromString(stringAngle: matchToFind.matchAngle) - child.zRotation) < 0.1) {
                    return true
                }
            }
        }
        return false
    }
    
    func checkIfMatchNotExistsOnBoard(matchToFind: matchModel)->Bool {
        for child in self.children {
            if let child = child as? MatchNode {
                if (abs(child.position.x - CGFloat(matchToFind.x)) < 0.1) && (abs(child.position.y - CGFloat(matchToFind.y)) < 0.1) && (!child.potentailMatch == Bool(truncating: matchToFind.matchType as NSNumber)){
                    return false
                }
            }
        }
        return true
    }
    
    func moveNodeToExtraNodePlace(selectedMatchNode: MatchNode, shouldIncrement: Bool? = true) {
        selectedMatchNode.zRotation = 0
        selectedMatchNode.position = extraNodePositionForIndex(index: gameService?.extraNodesRemain ?? 0)
        selectedMatchNode.name = "extraMatch"
        selectedMatchNode.canBecomeExtraMatch = false
        if shouldIncrement ?? true {
          gameService?.extraNodesRemain += 1
        } else {
            gameService?.extraNodesRemain -= 1
        }
    }
    
    func extraNodePositionForIndex(index: Int) -> CGPoint {
       return CGPoint.init(x: CGFloat(-280 + abs(index)*40), y: self.frame.minY + 20)
    }
    
    func getExtraNodeForIndex(index: Int) -> MatchNode? {
        for child in self.children {
            if child.name == "extraMatch" {
                if abs(child.position.x - CGFloat(-280 + (index-1)*40)) <= 0.5 {
                    return child as? MatchNode
                }
            }
        }
        return nil
    }
    
    func getSelectedMatchFor(touches: Set<UITouch>) -> MatchNode? {
        let touch = touches.first as UITouch?
        if let touchLocation = touch?.location(in: self) {
            if let targetNode = atPoint(touchLocation) as? MatchNode {
                return targetNode
            }
            else if let targetNode = atPoint(touchLocation) as? SKSpriteNode {
                if let baseNode = parentNodeOf(node: targetNode) as? MatchNode {
                   return baseNode
                }
            }
            else if let targetNode = atPoint(touchLocation) as? SKEmitterNode {
                if let baseNode = parentNodeOf(node: targetNode) as? MatchNode {
                   return baseNode
                }
            }
        }
        return nil
    }
    
    func parentNodeOf(node: SKNode) -> SKNode?
    {
        if let parentNode = node.parent
        {
            if parentNode is MatchNode
            {
                return parentNode
            }
            else
            {
                return parentNodeOf(node:parentNode)
            }
        }
        else
        {
            return nil
        }
    }
    
    func showConfetti() {
        // TEST!!
        // Сделать это через SpriteNode
        let lightBackgroundNode = SKSpriteNode.init(color: UIColor.black, size: self.size)
//        lightBackgroundNode.position = (self.view?.center)!
        lightBackgroundNode.alpha = 0.85
        lightBackgroundNode.name = "lightBackground"
        lightBackgroundNode.zPosition = 15
        self.addChild(lightBackgroundNode)

        let moveAction = SKAction.moveTo(y: 90, duration: 2.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5)
        let nextButton = SKSpriteNode.init(imageNamed: "next")
        nextButton.position = CGPoint.init(x: 0, y: 900)
        nextButton.size = CGSize.init(width: 200, height: 200)
        nextButton.color = globalGreenColor
        nextButton.name = "next"
        nextButton.colorBlendFactor = 1.0
        nextButton.zPosition = 20
        self.addChild(nextButton)
        
        let smallMovesAction = SKAction.moveTo(y: -30, duration: 3.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5)
        
        let reloadButton = SKSpriteNode.init(imageNamed: "reload")
        reloadButton.position = CGPoint.init(x: -200, y: 900)
        reloadButton.size = CGSize.init(width: 150, height: 150)
        reloadButton.color = globalGreenColor
        reloadButton.colorBlendFactor = 1.0
        reloadButton.zPosition = 20
        reloadButton.name = "reload"
        self.addChild(reloadButton)
        reloadButton.run(smallMovesAction) {
//                let reloadLabel = SKLabelNode.init(text: "PLAY AGAIN")
//                reloadLabel.fontColor = .white
//                reloadLabel.fontName = "HelveticaNeue-Medium"
//                reloadLabel.fontSize = 20
//                reloadLabel.horizontalAlignmentMode = .center
//                reloadLabel.zPosition = 20
//                reloadLabel.position = CGPoint.init(x: reloadButton.position.x, y: reloadButton.frame.minY - 20)
//                self.addChild(reloadLabel)
        }
        
        let menuButton = SKSpriteNode.init(imageNamed: "menu")
        menuButton.position = CGPoint.init(x: 200, y: 900)
        menuButton.size = CGSize.init(width: 150, height: 150)
        menuButton.color = globalGreenColor//themeLevel.buttonsTintColor
        menuButton.colorBlendFactor = 1.0
        menuButton.zPosition = 20
        menuButton.name = "menu"
        self.addChild(menuButton)
        menuButton.run(smallMovesAction) {
//                let menuLabel = SKLabelNode.init(text: "MENU")
//                menuLabel.fontColor = .white
//                menuLabel.fontName = "HelveticaNeue-Medium"
//                menuLabel.fontSize = 20
//                menuLabel.horizontalAlignmentMode = .center
//                menuLabel.zPosition = 20
//                menuLabel.position = CGPoint.init(x: menuButton.position.x, y: menuButton.frame.minY - 20)
//                self.addChild(menuLabel)
        }
        
        nextButton.run(moveAction) {
            let nextLabel = SKLabelNode.init(text: "NEXT")
            nextLabel.fontColor = .white
            nextLabel.fontName = "HelveticaNeue-Medium"
            nextLabel.fontSize = 20
            nextLabel.horizontalAlignmentMode = .center
            nextLabel.zPosition = 20
            nextLabel.position = CGPoint.init(x: nextButton.position.x, y: nextButton.frame.minY - 20)
            self.addChild(nextLabel)
            
            let menuLabel = SKLabelNode.init(text: "MENU")
            menuLabel.fontColor = .white
            menuLabel.fontName = "HelveticaNeue-Medium"
            menuLabel.fontSize = 20
            menuLabel.horizontalAlignmentMode = .center
            menuLabel.zPosition = 20
            menuLabel.position = CGPoint.init(x: menuButton.position.x, y: menuButton.frame.minY - 20)
            self.addChild(menuLabel)
            
            let reloadLabel = SKLabelNode.init(text: "PLAY AGAIN")
            reloadLabel.fontColor = .white
            reloadLabel.fontName = "HelveticaNeue-Medium"
            reloadLabel.fontSize = 20
            reloadLabel.horizontalAlignmentMode = .center
            reloadLabel.zPosition = 20
            reloadLabel.position = CGPoint.init(x: reloadButton.position.x, y: reloadButton.frame.minY - 20)
            self.addChild(reloadLabel)
        }
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        self.run(waitAction) {
            self.presentSuccess()
        }
        
        for _ in 0...5 {
            let confettiView = SwiftConfettiView(frame: self.frame)
            confettiView.type = .confetti
            confettiView.intensity = 1.2
            self.view?.addSubview(confettiView)
            
            confettiView.startConfetti()
        }
    }
    
    func presentSuccess() {
        let radius = CGFloat(300.0)
        let circleCenter = CGPoint.zero

        let string = "SUCCESS"
        let count = string.lengthOfBytes(using: String.Encoding.utf8)
        let angleIncr = CGFloat.pi/((CGFloat(count)+1) * 2)
        var angle = 2*CGFloat.pi/3
        // Loop over the characters in the string
        for character in string {
          // Calculate the position of each character
          let x = cos(angle) * radius + circleCenter.x
          let y = sin(angle) * radius + circleCenter.y
          let label = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
          label.text = "\(character)"
          label.zPosition = 16
          label.name = "char"
          label.position = CGPoint(x: x, y: y)
          // Determine how much to rotate each character
          label.zRotation = angle - CGFloat.pi / 2
          label.fontSize = 50
          self.addChild(label)
          angle -= angleIncr
        }
    }
    
    func removeConfetti() {
        if let views = self.view?.subviews {
            for view in views {
                if let view = view as? SwiftConfettiView {
                    view.removeFromSuperview()
                }
            }
        }
        let node = self.childNode(withName: "lightBackground")
        node?.removeFromParent()
    }
    
    func impactOccured(intense: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: intense)
        generator.impactOccurred()
    }
}
