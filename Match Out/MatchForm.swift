//
//  MatchForm.swift
//  Match Out
//
//  Created by Леванов Алексей on 13.09.2022.
//

import Foundation
import SpriteKit

// Класс, определяющий вид и поведение форм для меню
class MatchForm: SKNode {
    // TODO пока размеры
    static func triangle(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()
        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode.position = CGPoint.init(x: -35, y: 0)
        baseForm.addChild(matchNode)
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode2.floatAngleFromString(stringAngle: ".pi/6")
        matchNode2.position = CGPoint.init(x: 35, y: 0)
        baseForm.addChild(matchNode2)
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: 0, y: -58)
        baseForm.addChild(matchNode3)
        return baseForm
    }
}
