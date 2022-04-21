//
//  AssemblerFactory.swift
//  Rally
//
//  Created by Povilas Staskus on 9/26/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import Foundation
import Swinject
import RallyUI
import RallyData

class AssemblerFactory {

    func create() -> Assembler {
        let assemblies: [Assembly] = [
            ApplicationAssembly(),
            APIAssembly(baseUrl: Constants.API.baseUrl),
            UserAssembly(),
            EventAssembly(),
            RallyData.QuestionAnswerAssembly(),
            RallyData.QuestionsAssembly(),
            LoginAssembly(),
            RallyUI.QuestionsAssembly(),
            AnswerAssembly(),
            ViewTimeAssembly(),
            AnswerTimerAssembly(),
            RallyUI.EventsAssembly()
        ]

        let assembler = Assembler(assemblies)

        return assembler
    }
}
