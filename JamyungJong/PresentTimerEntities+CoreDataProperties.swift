//
//  PresentTimerEntities+CoreDataProperties.swift
//  JamyungJong
//
//  Created by 황석범 on 1/13/25.
//
//

import Foundation
import CoreData


extension PresentTimerEntities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PresentTimerEntities> {
        return NSFetchRequest<PresentTimerEntities>(entityName: "PresentTimerEntities")
    }

    @NSManaged public var hours: Int32
    @NSManaged public var minutes: Int32
    @NSManaged public var seconds: Int32
    @NSManaged public var remainingTime: Int32
    @NSManaged public var countdownTimer: Double

}

extension PresentTimerEntities : Identifiable {

}
