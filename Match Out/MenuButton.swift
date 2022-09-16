//
//  MenuButton.swift
//  Match Out
//
//  Created by Леванов Алексей on 13.09.2022.
//

import Foundation
import SpriteKit

enum MenuButtonSize: String, Decodable {
    case small            = "small"
    case medium           = "medium"
}

// Класс кнопки в главном меню
class MenuButton: SKNode {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(size: MenuButtonSize, title: String?, type: MatchType) {
        super.init()
        
        switch size {
        case .small:
            smallButtonInit(type: type)
        case .medium:
            mediumButtonInit(type: type)
        }
    }
      
    func smallButtonInit(type: MatchType) {
        
    }
    
    func mediumButtonInit(type: MatchType) {
        let matchNode = MatchNode.init(type: type, matchSize: .small)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode.position = CGPoint.init(x: 0, y: 100)
        self.addChild(matchNode)
        
        let matchNode2 = MatchNode.init(type: type, matchSize: .small)
        matchNode2.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode2.position = CGPoint.init(x: 185, y: 100)
        self.addChild(matchNode2)
        
        let matchNode3 = MatchNode.init(type: type, matchSize: .small)
        matchNode3.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: -185, y: 100)
        self.addChild(matchNode3)
        
        let matchNode4 = MatchNode.init(type: type, matchSize: .small)
        matchNode4.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi")
        matchNode4.position = CGPoint.init(x: -275, y: 0)
        self.addChild(matchNode4)

        let matchNode5 = MatchNode.init(type: type, matchSize: .small)
        matchNode5.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi")
        matchNode5.position = CGPoint.init(x: 275, y: 0)
        self.addChild(matchNode5)
        
        let matchNode6 = MatchNode.init(type: type, matchSize: .small)
        matchNode6.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode6.position = CGPoint.init(x: 0, y: -100)
        self.addChild(matchNode6)
        
        let matchNode7 = MatchNode.init(type: type, matchSize: .small)
        matchNode7.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode7.position = CGPoint.init(x: 185, y: -100)
        self.addChild(matchNode7)
        
        let matchNode8 = MatchNode.init(type: type, matchSize: .small)
        matchNode8.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode8.position = CGPoint.init(x: -185, y: -100)
        self.addChild(matchNode8)
    }
}
