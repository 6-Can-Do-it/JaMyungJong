//
//  RecentTimerEntities+CoreDataProperties.swift
//  JamyungJong
//
//  Created by 황석범 on 1/14/25.
//
//

import Foundation
import CoreData


extension RecentTimerEntities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentTimerEntities> {
        return NSFetchRequest<RecentTimerEntities>(entityName: "RecentTimerEntities")
    }

    @NSManaged public var hours: Int32
    @NSManaged public var minutes: Int32
    @NSManaged public var soundName: String?
    @NSManaged public var seconds: Int32

}

extension RecentTimerEntities : Identifiable {

}
