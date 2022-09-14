//
//  GetFoodNutrition.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 11/22/21.
//

import Foundation

class Food: Codable {
    var foods = [Foods]()
}

class Foods: Codable {
    var foodNutrients = [FoodNutrients]()
}

class FoodNutrients: Codable, CustomStringConvertible {
    var nutrientName: String? = ""
    var value: Double = 0

    var name: String {
        return nutrientName ?? ""
    }
    
    var description: String {
        return "\(nutrientName ?? "name failed"): \(value)"
    }
}
