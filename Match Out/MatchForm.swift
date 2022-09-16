//
//  MatchForm.swift
//  Match Out
//
//  Created by Леванов Алексей on 13.09.2022.
//

import Foundation
import SpriteKit

// Класс, определяющий вид и поведение форм для меню
// TODO пока размеры
class MatchForm: SKNode {
    
    // Маленький треугольник
    static func triangle(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()
        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode.position = CGPoint.init(x: -25, y: 0)
        baseForm.addChild(matchNode)
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode2.floatAngleFromString(stringAngle: ".pi/6")
        matchNode2.position = CGPoint.init(x: 25, y: 0)
        baseForm.addChild(matchNode2)
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode3)
        baseForm.name = "triangle"
        return baseForm
    }

    // Большой треугольник
    static func bigTwoPartTriangle(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()
        // Small triangle
        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode.position = CGPoint.init(x: -25, y: 0)
        baseForm.addChild(matchNode)
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode2.floatAngleFromString(stringAngle: ".pi/6")
        matchNode2.position = CGPoint.init(x: 25, y: 0)
        baseForm.addChild(matchNode2)
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode3)
        // Bottom part
        let matchNode4 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode4.zRotation = matchNode4.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode4.position = CGPoint.init(x: -68, y: -80)
        baseForm.addChild(matchNode4)
        let matchNode5 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode5.zRotation = matchNode5.floatAngleFromString(stringAngle: ".pi/6")
        matchNode5.position = CGPoint.init(x: 68, y: -80)
        baseForm.addChild(matchNode5)
        let matchNode6 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode6.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode6.position = CGPoint.init(x: -42, y: -120)
        baseForm.addChild(matchNode6)
        let matchNode7 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode7.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode7.position = CGPoint.init(x: 42, y: -120)
        baseForm.addChild(matchNode7)
        baseForm.name = "bigTwoPartTriangle"
        return baseForm
    }
    
    // Квадрат с ручкой
    static func squareWithHandle(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()

        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode)
        
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode2.position = CGPoint.init(x: 100, y: -40)
        baseForm.addChild(matchNode2)
        
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi")
        matchNode3.position = CGPoint.init(x: -50, y: -85)
        baseForm.addChild(matchNode3)

        let matchNode4 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode4.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi")
        matchNode4.position = CGPoint.init(x: 50, y: -85)
        baseForm.addChild(matchNode4)
        
        let matchNode5 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode5.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode5.position = CGPoint.init(x: 0, y: -130)
        baseForm.addChild(matchNode5)
        
        baseForm.name = "squareWithHandle"
        return baseForm
    }
    
    //  Два квадрата
    static func twoSquares(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()

        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode)
        
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi")
        matchNode3.position = CGPoint.init(x: -50, y: -85)
        baseForm.addChild(matchNode3)

        let matchNode4 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode4.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi")
        matchNode4.position = CGPoint.init(x: 50, y: -85)
        baseForm.addChild(matchNode4)
        
        let matchNode5 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode5.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode5.position = CGPoint.init(x: 0, y: -130)
        baseForm.addChild(matchNode5)
        
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode2.position = CGPoint.init(x: 100, y: -40)
        baseForm.addChild(matchNode2)
        
        let matchNode6 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode6.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi/2")
        matchNode6.position = CGPoint.init(x: 100, y: -130)
        baseForm.addChild(matchNode6)
        
        let matchNode7 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode7.zRotation = matchNode.floatAngleFromString(stringAngle: ".pi")
        matchNode7.position = CGPoint.init(x: 150, y: -85)
        baseForm.addChild(matchNode7)
        
        baseForm.name = "twoSquares"
        return baseForm
    }
    
    // Два треугольника
    static func twoTriangles(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()
        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode.position = CGPoint.init(x: -25, y: 0)
        baseForm.addChild(matchNode)
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode2.floatAngleFromString(stringAngle: ".pi/6")
        matchNode2.position = CGPoint.init(x: 25, y: 0)
        baseForm.addChild(matchNode2)
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode3)
        
        let matchNode4 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode4.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode4.position = CGPoint.init(x: 70, y: 0)
        baseForm.addChild(matchNode4)
        
        let matchNode5 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode5.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode5.position = CGPoint.init(x: 50, y: 40)
        baseForm.addChild(matchNode5)
        
        baseForm.name = "twoTriangles"
        return baseForm
    }

    static func triangleWithHandler(type: MatchType, matchSize: MatchSize)->MatchForm{
        let baseForm = MatchForm.init()
        let matchNode = MatchNode.init(type: type, matchSize: matchSize)
        matchNode.zRotation = matchNode.floatAngleFromString(stringAngle: "-.pi/6")
        matchNode.position = CGPoint.init(x: -25, y: 0)
        baseForm.addChild(matchNode)
        let matchNode2 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode2.zRotation = matchNode2.floatAngleFromString(stringAngle: ".pi/6")
        matchNode2.position = CGPoint.init(x: 25, y: 0)
        baseForm.addChild(matchNode2)
        let matchNode3 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode3.zRotation = matchNode3.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode3.position = CGPoint.init(x: 0, y: -40)
        baseForm.addChild(matchNode3)
        let matchNode4 = MatchNode.init(type: type, matchSize: matchSize)
        matchNode4.zRotation = matchNode4.floatAngleFromString(stringAngle: "-.pi/2")
        matchNode4.position = CGPoint.init(x: 93, y: -40)
        baseForm.addChild(matchNode4)
        
        baseForm.name = "triangleWithHandler"
        return baseForm
    }
}
