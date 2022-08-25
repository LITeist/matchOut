//
//  ThemeService.swift
//  Match Out
//
//  Created by Леванов Алексей on 24.08.2022.
//

import Foundation
import SpriteKit

class ThemeService {
    static func backgroundColorForLevelType(levelType: LevelColorType?)->UIColor {
        switch levelType {
        case .plainWhite:
            return .white
        case .plainBlack:
            return .black
        case .neonBar:
            return .black
        case .alchimicLab:
            return .yellow
        case .none:
            return .black
        }
    }
}
