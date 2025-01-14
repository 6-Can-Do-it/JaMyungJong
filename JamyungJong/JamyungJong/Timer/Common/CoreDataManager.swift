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
    
    var recentTimers: [(hours: Int, minutes: Int, seconds: Int, soundName: String)] = []
    
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
    
    func saveRecentTimer(_ timer: (hours: Int, minutes: Int, seconds: Int, soundName: String)) {
        let context = persistentContainer.viewContext
        let entity = RecentTimerEntities(context: context)
        entity.hours = Int32(timer.hours)
        entity.minutes = Int32(timer.minutes)
        entity.seconds = Int32(timer.seconds)
        entity.soundName = timer.soundName

        do {
            try context.save()
        } catch {
            print("Failed to save timer: \(error)")
        }
    }
    
    func loadRecentTimers() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<RecentTimerEntities> = RecentTimerEntities.fetchRequest()

        do {
            let fetchedTimers = try context.fetch(fetchRequest)
            recentTimers = fetchedTimers.map {
                (hours: Int($0.hours), minutes: Int($0.minutes), seconds: Int($0.seconds), soundName: $0.soundName ?? "defaults")
            }
        } catch {
            print("Failed to load recent timers: \(error)")
        }
    }
    
    // 최근 타이머 삭제
    func deleteRecentTimer(_ timer: RecentTimerEntities) {
        context.delete(timer)
        saveContext()
        loadRecentTimers()
    }
}
