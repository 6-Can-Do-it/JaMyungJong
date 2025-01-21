//
//  AppDelegate.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/7/25.
//

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 윈도우 생성 및 설정
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // TabBarController를 루트 뷰 컨트롤러로 설정
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        window.makeKeyAndVisible()
        self.window = window
        // 알림 권한 요청
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                print("알림 권한 승인")
            } else {
                print("알림 권한 거부")
            }
        }
        
//        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//            guard let navigationController = window.rootViewController as? UINavigationController else {
//                completionHandler()
//                return
//            }
//            
//            NotificationManager.shared.handleAlarmTrigger(navigationController: navigationController)
//            completionHandler()
//        }
//        
//        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "JamyungJong")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
