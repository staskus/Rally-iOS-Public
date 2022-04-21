//
//  QuestionInAreaCalculator.swift
//  
//
//  Created by Povilas Staskus on 11/23/19.
//

import Foundation
import RallyCore
import CoreLocation

class QuestionInAreaCalculator {
    class func isQuestionInArea(_ question: Question, in location: CLLocation?) -> Bool {
        guard let distance = getDistance(from: question, currentLocation: location) else { return false }
        
        return abs(distance) <= question.radius
    }
    
    class func getDistance(from question: Question, currentLocation: CLLocation?) -> Double? {
        guard
            let currentLocation = currentLocation,
            let latitude = Double(question.latitude),
            let longitude = Double(question.longitude) else {
                return nil
        }
        
        return currentLocation.distance(
            from: CLLocation(latitude: latitude, longitude: longitude)
        )
    }
}
