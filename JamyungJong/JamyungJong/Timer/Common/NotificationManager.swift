//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/14/25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    // 싱글톤 인스턴스
    static let shared = NotificationManager()
    
    private init() {} // 외부에서 초기화 방지

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
    func scheduleNotification(for timer: (hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)) {
        let content = UNMutableNotificationContent()
        content.title = "타이머 종료" // 알림 제목
        content.body = "설정된 타이머가 종료되었습니다." // 알림 내용
        content.sound = .default // 기본 알림 소리
        
        // 트리거 설정: 지정된 시간 후 알림 표시
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timer.remainingTime), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 스케줄링 오류: \(error)")
            } else {
                print("알림이 성공적으로 스케줄링되었습니다.")
            }
        }
    }
}
