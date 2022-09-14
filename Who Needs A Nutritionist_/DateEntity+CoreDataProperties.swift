//
//  DateEntity+CoreDataProperties.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 12/7/21.
//
//

import Foundation
import CoreData


extension DateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateEntity> {
        return NSFetchRequest<DateEntity>(entityName: "DateEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var meals: NSSet?
    
    public var mealsArray: [ListMeals] {
        let set = meals as? Set<ListMeals> ?? []
        for index in set {
            print("\(index.text)")
        }
        return set.sorted {
            $0.unwrappedMeal < $1.unwrappedMeal
        }
    }
    
    public var count: Int {
        let set = meals as? Set<ListMeals> ?? []
        var count = 0
        for _ in set {
            count = count + 1
            print("Count is now:", "\(count)")
        }
        return count
    }
}

// MARK: Generated accessors for meals
extension DateEntity {

    @objc(addMealsObject:)
    @NSManaged public func addToMeals(_ value: ListMeals)

    @objc(removeMealsObject:)
    @NSManaged public func removeFromMeals(_ value: ListMeals)

    @objc(addMeals:)
    @NSManaged public func addToMeals(_ values: NSSet)

    @objc(removeMeals:)
    @NSManaged public func removeFromMeals(_ values: NSSet)

}

extension DateEntity : Identifiable {

}
