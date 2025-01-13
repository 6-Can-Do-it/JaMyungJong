//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/13/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var recentTimers: [(hours: Int, minutes: Int, seconds: Int)] = []
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JamyungJong")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveRecentTimer(_ timer: (hours: Int, minutes: Int, seconds: Int)) {
        let context = CoreDataManager.shared.context
        let newTimer = RecentTimerEntities(context: context)
        newTimer.hours = Int32(timer.hours)
        newTimer.minutes = Int32(timer.minutes)
        newTimer.seconds = Int32(timer.seconds)

        CoreDataManager.shared.saveContext()
    }
    
    func loadRecentTimers() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<RecentTimerEntities> = RecentTimerEntities.fetchRequest()

        do {
            let timers = try context.fetch(fetchRequest)
            recentTimers = timers.map { (hours: Int($0.hours), minutes: Int($0.minutes), seconds: Int($0.seconds)) }
        } catch {
            print("Failed to fetch timers: \(error)")
        }
    }
    
    // 최근 타이머 삭제
    func deleteRecentTimer(_ timer: RecentTimerEntities) {
        context.delete(timer)
        saveContext()
        loadRecentTimers()
    }
}
