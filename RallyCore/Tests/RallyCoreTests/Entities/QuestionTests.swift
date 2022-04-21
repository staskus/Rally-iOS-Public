//
//  QuestionTests.swift
//  RallyCoreTests
//
//  Created by Povilas Staskus on 9/28/19.
//  Copyright © 2019 ItWorksMobile. All rights reserved.
//

import XCTest
@testable import RallyCore

final class QuestionTests: XCTestCase {
    func testQuestionsParsed_validData() throws {
        let data = questions

        let questions = try Data(data.utf8).decoded() as Questions

        XCTAssertNotNil(questions)
    }
}

// swiftlint:disable line_length
extension QuestionTests {
    var questions: String {
        return """
        {"EventID":"9876","ActivationTime":"2020-04-12T16:30:21+00:00","DeactivationTime":"2020-04-12T16:30:21+00:00","Questions":
          [{"QNo":1,"QAnswered": {"State": false}, "QSeenTimestamp": "2020-05-05T20:29:12+03:00", "QName":"Best racer","QAnswerOnce": true,"Latitude":"56.9754811","Longitude":"24.1108338,14","Radius":500,"QImage":"http://autorally.lv/zxc/rallypoll/img/760145-bestracer.png","Text":"Who is best racer of all time","Type":"choice","Answers":[{"ANo":1,"Type":"text","Value":"Michael Schumacher"},{"ANo":2,"Type":"text","Value":"Ayrton Senna"},{"ANo":3,"Type":"text","Value":"Michael Jordan"}]},
           {"QNo":2,"QAnswered": {"State": true,"Timestamp": "2020-04-12T16:19:21+00:00","Value": "2"},"QName":"Longest circuit","Latitude":"56.9754811","Longitude":"24.1108338,14","Radius":450,"QImage":"http://autorally.lv/zxc/rallypoll/img/610164-circuit.png","Text":"The longest F1 circuit","Type":"choice","Answers":[{"ANo":1,"Type":"text","Value":"Circuit de Spa-Francorchamps"},{"ANo":2,"Type":"text","Value":"Autodromo Nazionale Monza"},{"ANo":3,"Type":"text","Value":"Circuit de Monaco"}]},
           {"QNo":3,"QAnswered": {"State": true,"Timestamp": "2020-04-12T16:30:21+00:00","Value": "1976"}, "QName":"The 1st WRC event","Latitude":"56.9754811","Longitude":"24.1108338,14","Radius":1000,"QImage":"http://autorally.lv/zxc/rallypoll/img/413809-wrcevent.png","Text":"Year of the first WRC event","Type":"number"},
           {"QNo":4,"QAnswered": {"State": false},"QName":"Capital of Lithuania","Latitude":"56.9754811","Longitude":"24.1108338,14","Radius":2000,"QImage":"http://autorally.lv/zxc/rallypoll/img/340097-lithuania.png","Text":"Name of the capital of Lithuania","Type":"text"},
           {"QNo":5,"QAnswered": {"State": false},"QName":"Solberg's car","Latitude":"56.9754811","Longitude":"24.1108338,14","Radius":180,"QImage":"http://autorally.lv/zxc/rallypoll/img/650077-solberg.png","Text":"Which of these cars did Petter Solberg participate in the WRC?","Type":"choice","QViewTiming": true,
                "Answers":[{"ANo":1,"Type":"image","AImage":"https://autorally.lv/zxc/rallypoll/img/245301-ford.png"},
        {"ANo":2,"Type":"image","AImage":"https://autorally.lv/zxc/rallypoll/img/764351-mitsubishi.png"},
        {"ANo":3,"Type":"image","AImage":"https://autorally.lv/zxc/rallypoll/img/891243-subaru.png"}]
           }
          ]}
        """
    }
}
