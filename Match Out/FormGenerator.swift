//
//  FormGenerator.swift
//  Match Out
//
//  Created by Леванов Алексей on 13.09.2022.
//

import Foundation

//  Класс генерации формы
//  TODO определить формы и описать в генерации
class FormGenerator {
    var potentailMatch: Bool = false // Является ли спичка placeholder'ом
    var canBecomeExtraMatch: Bool = false // Можно ли убрать спичку при нажатии в доступные спички
    var isSelectedMatch: Bool = false // Выбрана ли спичка в моменте

    static func generateRandomMatchForm(type: MatchType)->MatchForm {
        let randomValue = Int.random(in: 0..<6)
        switch randomValue {
        case 0:
            return MatchForm.triangle(type: type, matchSize: .extraSmallMenu)
        case 1:
            return MatchForm.bigTwoPartTriangle(type: type, matchSize: .extraSmallMenu)
        case 2:
            return MatchForm.squareWithHandle(type: type, matchSize: .extraSmallMenu)
        case 3:
            return MatchForm.twoSquares(type: type, matchSize: .extraSmallMenu)
        case 4:
            return MatchForm.twoTriangles(type: type, matchSize: .extraSmallMenu)
        default:
            return MatchForm.triangleWithHandler(type: type, matchSize: .extraSmallMenu)
        }
    }
}
