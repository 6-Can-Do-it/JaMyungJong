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
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourProjectName")
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
    
    // 최근 타이머 저장
    func saveRecentTimer(hours: Int, minutes: Int, seconds: Int) {
        let timer = RecentTimer(context: context)
        timer.hours = Int32(hours)
        timer.minutes = Int32(minutes)
        timer.seconds = Int32(seconds)
        saveContext()
    }
    
    // 최근 타이머 불러오기
    func fetchRecentTimers() -> [RecentTimer] {
        let fetchRequest: NSFetchRequest<RecentTimer> = RecentTimer.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "hours", ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recent timers: \(error.localizedDescription)")
            return []
        }
    }
    
    // 최근 타이머 삭제
    func deleteRecentTimer(_ timer: RecentTimer) {
        context.delete(timer)
        saveContext()
    }
}
