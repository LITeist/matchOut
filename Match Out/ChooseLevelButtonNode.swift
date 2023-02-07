//
//  ChooseLevelButtonNode.swift
//  Match Out
//
//  Created by Леванов Алексей on 07.02.2023.
//

/* Кнопка выбора элементов в меню игры */
import Foundation
import SpriteKit

let chooseButtonSize: CGFloat = 90

class ChooseLevelButtonNode: SKSpriteNode {
    
    var levelToSelect: Int = 0
    var isPressed: Bool = false
        
    var selectedHandler: () -> Void = {print("No Button action is set")}

    init(buttonTitle: String, isEnabled: Bool = false, textColor: UIColor, isSelected: Bool = false, matchType: MatchType) {
        super.init(texture: nil, color: .clear, size: CGSize.init(width: 90, height: 90))
        
        self.isUserInteractionEnabled = isEnabled
        let label = SKLabelNode.init(text: buttonTitle)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.fontSize = 55
        label.fontName = "HelveticaNeue-Bold"
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        label.zPosition = 3
        label.fontColor = isEnabled ? textColor : textColor.withAlphaComponent(0.5)
        self.addChild(label)
        
        let match = MatchNode.init(type: matchType, matchSize: .extraSmallMenu)
        match.zRotation = match.floatAngleFromString(stringAngle: "-.pi/2")
        match.position = CGPoint.init(x: 0, y: label.frame.minY - label.frame.height/1.5)
        match.alpha = isSelected ? 1 : 0
        self.addChild(match)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeButtonState(state: true, touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       changeButtonState(state: false, touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeButtonState(state: false, touches: touches)
    }
    
    func changeButtonState(state: Bool, touches: Set<UITouch>) {
        if isUserInteractionEnabled {
            self.isPressed = state
            if state == false {
                self.selectedHandler()
            }
        }
    }
}
