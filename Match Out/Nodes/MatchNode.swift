//
//  MatchNode.swift
//  Match Out
//
//  Created by Леванов Алексей on 30.08.2022.
//

import Foundation
import SpriteKit

enum MatchType: String, Decodable {
    case green         = "green"
    case red           = "red"
    case black         = "black"
    case brown         = "brown"
    case blue          = "blue"
}

var potentailMatch: Bool = false
class MatchNode: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type: MatchType, matchSize: MatchSize, isPotentialMatch: Bool? = false) {
        var imageName: String
        switch type {
        case .green:
             imageName = "greenMatch"
        case .red:
            imageName = "redMatch"
        case .black:
            imageName = "blackMatch"
        case .brown:
            imageName = "brownMatch"
        case .blue:
            imageName = "blueMatch"
        }
        if isPotentialMatch ?? false {
            imageName = "ghostMatch"
        }
        var size: CGSize
        switch matchSize {
        case .extraSmall:
            size = CGSize.init(width: 42.4, height: 150)
        case .small:
            size = CGSize.init(width: 56.5, height: 200)
        case .medium:
            size = CGSize.init(width: 70.8, height: 250)
        case .big:
            size = CGSize.init(width: 85, height: 300)
        }
        potentailMatch = isPotentialMatch ?? false
        super.init(texture: SKTexture.init(imageNamed: imageName), color: .clear, size: size)
    }
        
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = "baseNode"
        self.physicsBody?.isDynamic = false
    }
    
    func floatAngleFromString(stringAngle: String)->CGFloat {
        if stringAngle == ".pi/2" {
            return .pi/2
        }
        else if stringAngle == ".pi/4" {
                return .pi/4
        } else if stringAngle == "-.pi/4" {
            return -.pi/4
        } 
        else if stringAngle == ".pi" {
            return .pi
        } else if stringAngle == "-.pi/2" {
            return -.pi/2
        } else if stringAngle == ".pi/3" {
            return .pi/3
        } else if stringAngle == "-.pi/3" {
            return -.pi/3
        } else if stringAngle == ".pi/6" {
            return .pi/6
        } else if stringAngle == "-.pi/6" {
            return -.pi/6
        }
        return 0
    }

}
