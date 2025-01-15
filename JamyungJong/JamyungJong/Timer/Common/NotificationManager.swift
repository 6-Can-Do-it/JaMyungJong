//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/14/25.
//

import UserNotifications
import UIKit

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    // 싱글톤 인스턴스
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    /// 알림 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 오류: \(error)")
                completion(false)
            } else {
                completion(granted)
            }
        }
    }
    
    /// 타이머 종료 알림 스케줄링
    func scheduleNotification(withSoundName soundName: String?, after seconds: TimeInterval, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = "자명종"
        content.body = "타이머가 종료되었습니다."
        
        if let soundName = soundName, !soundName.isEmpty {
            print("\(soundName).mp3")
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).mp3"))
        } else {
            content.sound = .default
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error)")
            } else {
                print("알림 스케줄링 성공")
            }
        }
    }
    
    /// 특정 시간에 알림 스케줄링

    func scheduleAlarmNotification(alarmData: AlarmData) {
        guard alarmData.isEnabled else {
            print("알람이 비활성화 상태입니다. 스케줄링을 건너뜁니다.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "자명종"
        content.body = "알람이 울립니다!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "default_ringtone.mp3"))
        
        // 캘린더 및 시간 구성
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: alarmData.time)
        
        for (index, shouldRepeat) in alarmData.repeatDays.enumerated() {
            guard shouldRepeat else { continue }
            
            var components = timeComponents
            components.weekday = index + 1 // index: 0(일) ~ 6(토), weekday: 1(일) ~ 7(토)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: "alam\(UUID().uuidString)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("알람 스케줄링 오류: \(error.localizedDescription)")
                } else {
                    print("알람이 성공적으로 스케줄링되었습니다. 요일: \(index + 1)")
                }
            }
        }
    }
    
    func handleAlarmTrigger(navigationController: UINavigationController?) {
        DispatchQueue.main.async {
            let alarmRingVC = AlarmRingViewController()
            navigationController?.pushViewController(alarmRingVC, animated: true)
        }
    }
    
    // UNUserNotificationCenterDelegate 메서드 구현
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // 기본 동작 (배너 클릭 또는 올림)
        if response.notification.request.identifier.contains("alam") {
            print("Alam action triggered, navigating to controller.")
            
            if let topViewController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
                DispatchQueue.main.async {
                    let alarmRingVC = AlarmRingViewController()
                    topViewController.pushViewController(alarmRingVC, animated: true)
                }
            }
        } else {
            print("알람과 관련 없는 알림입니다.")
        }
        
        completionHandler()
    }
}
