//
//  GameService.swift
//  Match Out
//
//  Created by Леванов Алексей on 03.09.2022.
//

import Foundation
import SpriteKit
import StoreKit


class GameService {
    var extraNodesRemain: Int = 0 // Сколько осталось спичек для переноса
    var numberOfSucceedLevelsAtTheSameTime: Int = 0 // Сколько уровней подряд успешно прошли
    let numberOfLevelsToShowAds: Int = 4 // Сколько надо пройти, чтобы смотреть рекламу
//    var userData: UserGameData?
    var inAppPurchaseProduct: SKProduct?
    
    init() {
//        loadCurrentGameStatus()
//        checkInAppPurchase()
    }
    
    // Можно ли переложить спичку на спичку
    // Возможно логику придется доработать
    func canPlaceMatches(from matchA:MatchNode, to matchB:MatchNode) -> Bool {
        if matchA.potentailMatch == true {
           return false
        }

        if matchB.potentailMatch == false {
           return false
        }

        return true
    }
    
//    func getUserMaxLevelNumber() -> Int {
//        return userData?.maxReachedLevel ?? 0
//    }
//
//    func getUserLevelNumber() -> Int {
//        return userData?.currentLevel ?? 0
//    }
//
//    func getUserLevel()->String {
//        return "level_" + String(userData?.currentLevel ?? 0)
//    }
//
//    func setUserLevel(level: Int) {
//        currentLevelSteps = 0
//        userData?.currentLevel = level
//        saveCurrentGameStatus()
//    }
//
//    func incrementUserLevel() {
//        currentLevelSteps = 0
//        numberOfSucceedLevelsAtTheSameTime = numberOfSucceedLevelsAtTheSameTime + 1
//        if let currentLevel = userData?.currentLevel {
//            userData?.currentLevel = currentLevel + 1
//            if let userData = userData {
//                if userData.currentLevel > userData.maxReachedLevel {
//                    userData.maxReachedLevel = userData.currentLevel
//                }
//            }
//            saveCurrentGameStatus()
//        }
//    }
//
//    func reloadLevel() {
//        currentLevelSteps = 0
//        numberOfSucceedLevelsAtTheSameTime = 0
//    }
//
//    func getResultForLevel(levelModel: LevelModel)->ResultType {
//        // считаем количество шагов и делим на оптимальное количество шагов по уровню
//        if currentLevelSteps <= levelModel.optimumNumberOfSteps {
//            return .perfect
//        } else if currentLevelSteps <= levelModel.optimumNumberOfSteps + 3 {
//            return .awesome
//        } else  {
//            return .good
//        }
//    }
//
//    func canPerformAnimationInBaseGame(from containerA:BaseNode, to containerB:BaseNode) -> Bool {
//        if containerB.waterLevel == 0 {
//            return true
//        }
//
//        if containerB.numberOfLayers <= containerB.waterLevel {
//            return false
//        }
//
//        if containerB.waterNodes.last?.color != containerA.waterNodes.last?.color {
//            return false
//        }
//
//        if containerB.isSelected || containerA.canBeSelectedToPoreIn == false {
//            return false
//        }
//
//        return true
//    }
//
//    // Проверяем
//    func numberOfLayersToPerform(from containerA:BaseNode, to containerB:BaseNode) -> Int {
//        // проверяем, сколько в контейнере B
//        let containerBFreeSpace: Int = containerB.numberOfLayers - containerB.waterLevel
//        // проверяем, сколько можем перелить из A
//        var containerACanPore: Int = 1
//        // from -  количество элементов массива -1 для индексов, to - до значения не включительно
//        for i in stride(from: containerA.waterNodes.count-1, to: 0, by: -1) {
//            if containerA.waterNodes[i].color == containerA.waterNodes[i-1].color {
//                containerACanPore = containerACanPore+1
//            } else {
//                break
//            }
//        }
//        if isMisteryLevel() {
//            let minValue = min(containerBFreeSpace, containerACanPore)
//            return min(minValue, 1)
//        }
//        return min(containerBFreeSpace, containerACanPore)
//    }
//
//    //  Проверяет, завершена ли стандартная игра успешно
//    //  Завершена успешно, если все контейнеры заполнены одним цветом и/или пустые
//    func checkIfRegularGameIsFinishedSuccessful(scene: SKScene)->Bool {
//        for node in scene.children {
//            if let baseNode = node as? BaseNode {
//                if baseNode.canBeSelected == true && baseNode.waterNodes.count > 0 {
//                    return false
//                }
//            }
//        }
//        return true
//    }
//
//    // Сохранить текущий прогресс
//    func saveCurrentGameStatus() {
//        do {
//            try UserDefaults.standard.setObject(userData, forKey: "UserData")
//            UserDefaults.standard.synchronize()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    // Загрузить текущий прогресс по игре при старте и вернуть модель данных
//    func loadCurrentGameStatus() {
//        do {
//            userData = try UserDefaults.standard.getObject(forKey: "UserData", castTo: UserGameData.self)
//        } catch {
//            print(error.localizedDescription)
//        }
//        if userData == nil {
//            userData = UserGameData()
//        }
//    }
//
//    func shouldShowAdsDependOnProgress()->Bool {
//        if numberOfSucceedLevelsAtTheSameTime >= numberOfLevelsToShowAds {
//            numberOfSucceedLevelsAtTheSameTime = 0
//            return true
//        }
//
//        return false
//    }
//
//
//    func provideExtraContainer()->BottleNode {
//        self.didProvideExtraBottle = true
//
//        let levelModel = LevelParser().loadLevel(levelName: self.getUserLevel())
//        let bottleNode = BottleNode.init(levelType: levelModel?.mapType ?? .plainWhite)
//        bottleNode.numberOfLayers = 4
//        bottleNode.affectedByGravity = false
//        bottleNode.physicsBody?.allowsRotation = false
//        bottleNode.physicsBody?.isDynamic = false
//        bottleNode.physicsBody?.categoryBitMask = 4294967295
//        bottleNode.physicsBody?.collisionBitMask = UInt32(150)
//        bottleNode.physicsBody?.fieldBitMask = 4294967295
//        bottleNode.zPosition = 150
//        bottleNode.position = CGPoint.init(x: 0, y: -400)
//        return bottleNode
//    }
//
//    func checkInAppPurchase() {
//        RazeFaceProducts.store.requestProducts{ [weak self] success, products in
//          guard let self = self else { return }
//          if success {
//              self.inAppPurchaseProduct = products?.first
//          }
//       }
//    }
//
//    func buyInAppPurchase() {
//        if let userData = userData {
//            if let productToBuy = self.inAppPurchaseProduct {
//                if userData.isAdsInAppPurchasedPaid == false {
//                    RazeFaceProducts.store.buyProduct(productToBuy)
//                }
//            }
//        }
//    }
//
//    // Определяет, является ли уровень уровнем со скрытыми слоями
//    func isMisteryLevel()->Bool {
//        if let userData = userData {
//            return userData.currentLevel > misteryLevelsMin
//        }
//
//        return false
//    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
