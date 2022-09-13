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

    static func generateMatchForm()->MatchForm {
        return MatchForm()
    }
}
