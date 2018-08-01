//
//  News+CoreDataProperties.swift
//  
//
//  Created by yfm on 2018/8/1.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var source: String?
    @NSManaged public var id: String?
}
