//
//  TabBarController.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/14/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
        selectedIndex = 0
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupViewControllers() {
        // 각 탭의 뷰컨트롤러 생성
        let alarmVC = AlarmListViewController()
        let morningVC = MorningViewController()
        let timerVC = TimerViewMainController()
        let stopwatchVC = StopWatchViewController()
        
        // 각 뷰컨트롤러의 기본 설정
        alarmVC.view.backgroundColor = .black
        morningVC.view.backgroundColor = .systemTeal
        timerVC.view.backgroundColor = .black
        stopwatchVC.view.backgroundColor = .black
        
        // 탭바 아이템 설정
        alarmVC.tabBarItem = UITabBarItem(
            title: "알람",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill")
        )
        
        morningVC.tabBarItem = UITabBarItem(
            title: "아침",
            image: UIImage(systemName: "sun.max"),
            selectedImage: UIImage(systemName: "sun.max.fill")
        )
        
        timerVC.tabBarItem = UITabBarItem(
            title: "타이머",
            image: UIImage(systemName: "timer"),
            selectedImage: UIImage(systemName: "timer.fill")
        )
        
        stopwatchVC.tabBarItem = UITabBarItem(
            title: "스톱워치",
            image: UIImage(systemName: "stopwatch"),
            selectedImage: UIImage(systemName: "stopwatch.fill")
        )
        
        // 네비게이션 컨트롤러로 감싸기
        let alarmNav = UINavigationController(rootViewController: alarmVC)
        let morningNav = UINavigationController(rootViewController: morningVC)
        let timerNav = UINavigationController(rootViewController: timerVC)
        let stopwatchNav = UINavigationController(rootViewController: stopwatchVC)
        
        // 탭바 컨트롤러에 뷰컨트롤러 설정
        viewControllers = [alarmNav, morningNav, timerNav, stopwatchNav]
    }
    
    private func setupTabBarAppearance() {
        // 탭바 스타일 설정
        tabBar.backgroundColor = .black
        tabBar.tintColor = .systemCyan // 선택된 아이템 색상
        tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템 색상
    }
}
