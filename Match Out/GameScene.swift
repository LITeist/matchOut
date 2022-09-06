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
    
    override func didMove(to view: SKView) {
        // TODO проверяем текущий уровень
        // Парсим уровень
        // Собираем уровень, исходя из ThemeModel
        
        // TODO первый шаг - проверяем как отображается спичка +
        // Второй шаг - поправить уровень в JSON на основе собранного кода -
        // Третий шаг - парсим уровень
        self.gameService = GameService()
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
        // Проверяем, можно ли добавить или убрать спичку
        // Если можно убирать и спичка настоящая - убираем, иначе ничего не делаем
        // Если можно добавлять, есть спички и нажатая сейчас с спичка - плейсхолджер - переносим. Иначе ничего не делаем
        if let selectedMatchNode = getSelectedMatchFor(touches: touches) {
            switch levelModel?.gameplayType {
                case .add:
                    if selectedMatchNode.potentailMatch == true {
//                        enumerateChildNodes(withName: "extraMatch") {
//                            (node, stop) in
//                            node.zRotation = selectedMatchNode.zRotation
//                            node.position = selectedMatchNode.position
//                            node.name = ""
//                            if let matchMode = node as? MatchNode {
//                                matchMode.canBecomeExtraMatch = true
//                                self.gameService?.extraNodesRemain -= 1
//                            }
//                            stop.initialize(to: true)
                        if let childNode = getExtraNodeForIndex(index: self.gameService?.extraNodesRemain ?? 0) {
                            childNode.zRotation = selectedMatchNode.zRotation
                            childNode.position = selectedMatchNode.position
                            childNode.canBecomeExtraMatch = true
                            self.gameService?.extraNodesRemain -= 1
                        }
                    } else {
                        if selectedMatchNode.canBecomeExtraMatch {
                            moveNodeToExtraNodePlace(selectedMatchNode: selectedMatchNode)
                        }
                }
                case .remove:
                    if selectedMatchNode.potentailMatch == false && selectedMatchNode.name != "extraMatch" {
                        //  Очень странная, но рабочая логика :)
                        if abs(gameService?.extraNodesRemain ?? 0) - abs(self.levelModel?.extraMatches ?? 0) < abs(self.levelModel?.extraMatches ?? 0)  {
                            moveNodeToExtraNodePlace(selectedMatchNode: selectedMatchNode, shouldIncrement: false)
                        }
                    } else if selectedMatchNode.potentailMatch == true {
                        // Вынести в общий блог с параметром shouldIncrement
                        if let childNode = getExtraNodeForIndex(index: abs(self.gameService?.extraNodesRemain ?? 0)) {
                            childNode.zRotation = selectedMatchNode.zRotation
                            childNode.position = selectedMatchNode.position
                            childNode.canBecomeExtraMatch = true
                            childNode.name = ""
                            self.gameService?.extraNodesRemain += 1
                        }
                    }
                //
                case .none:
                    break
                //
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO проверяем сходимость игры
        if let solvesArray = self.levelModel?.resolves {
            for solve in solvesArray {
                    for matchModel in solve.matchArray {
                        if self.levelModel?.gameplayType == .remove {
                            if checkIfMatchNotExistsOnBoard(matchToFind: matchModel) == false {
                                return
                            }
                        } else if self.levelModel?.gameplayType == .add {
                        // Если не проходит проверка хоть раз - break цикла делаем
                            if checkIfMatchExistsOnBoard(matchToFind: matchModel) == false {
                                return
                            }
                        }
                    }
            }
        }
        print("успех")
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

}
