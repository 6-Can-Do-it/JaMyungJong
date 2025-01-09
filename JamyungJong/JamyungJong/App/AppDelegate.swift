//
//  AppDelegate.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/7/25.
//

import UIKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // UIWindow 생성 및 초기 화면 설정
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MissionViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = UINavigationController(rootViewController: MainViewController())
//        window.makeKeyAndVisible()
//        self.window = window
//        return true
//    }
//}
//
