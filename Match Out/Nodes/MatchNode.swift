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

class MatchNode: SKSpriteNode {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type: MatchType) {
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
        super.init(texture: SKTexture.init(imageNamed: imageName), color: .clear, size: CGSize.init(width: 42, height: 150))
    }
        
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.name = "baseNode"
        self.physicsBody?.isDynamic = false
    }
    
    func floatAngleFromString(stringAngle: String)->CGFloat {
        if stringAngle == ".pi/2" {
            return .pi/2
        } else if stringAngle == "pi" {
            return .pi
        } else if stringAngle == "-.pi/2" {
            return -.pi/2
        }
        return 0
    }
}
