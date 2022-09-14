//
//  ListMeals+CoreDataProperties.swift
//  Who Needs A Nutritionist?
//
//  Created by AnthonyProject on 12/7/21.
//
//

import Foundation
import CoreData


extension ListMeals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListMeals> {
        return NSFetchRequest<ListMeals>(entityName: "ListMeals")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var date: String
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var dateEnt: DateEntity?

    public var unwrappedMeal: String {
        text 
    }
}

extension ListMeals : Identifiable {

}
