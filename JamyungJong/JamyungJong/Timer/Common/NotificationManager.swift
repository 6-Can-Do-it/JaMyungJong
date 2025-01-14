//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/14/25.
//

import UserNotifications

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
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).mp3"))
        } else {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Ringtone.mp3"))
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
    func scheduleAlarmNotification(at date: Date, withSoundName soundName: String?) {
        let content = UNMutableNotificationContent()
        content.title = "자명종"
        content.body = "알람이 울립니다!"
        
        // 사용자 지정 소리 설정
        if let soundName = soundName, !soundName.isEmpty {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).mp3"))
        } else {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Ringtone.mp3"))
        }
        
        // 알람 시간 트리거 설정
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알람 스케줄링 오류: \(error.localizedDescription)")
            } else {
                print("알람이 성공적으로 스케줄링되었습니다.")
            }
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
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("Default action triggered, stopping sound.")
            SoundManager.shared.stopSound()
        }
        
        completionHandler()
    }
}
