//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import Foundation

final class TimerManager {
    private(set) var presentTimers: [(hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)] = []
    private(set) var recentTimers: [(hours: Int, minutes: Int, seconds: Int)] = []
    
    // 현재 타이머 추가
    func addPresentTimer(hours: Int, minutes: Int, seconds: Int) {
        let remainingTime = (hours * 3600) + (minutes * 60) + seconds
        presentTimers.append((hours, minutes, seconds, remainingTime, nil))
    }
    
    // 최근 타이머 추가
    func addRecentTimer(hours: Int, minutes: Int, seconds: Int) {
        recentTimers.insert((hours, minutes, seconds), at: 0)
    }
    
    // 현재 타이머 반환
    func getPresentTimer(at index: Int) -> (hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)? {
        guard presentTimers.indices.contains(index) else { return nil }
        return presentTimers[index]
    }
    
    // 현재 타이머 업데이트
    func updatePresentTimer(at index: Int, with timer: (hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)) {
        guard presentTimers.indices.contains(index) else { return }
        presentTimers[index] = timer
    }
    
    // 모든 타이머 초기화
    func resetPresentTimers() {
        presentTimers.removeAll()
    }
    
    // 모든 타이머가 종료되었는지 확인
    func areAllTimersFinished() -> Bool {
        return presentTimers.allSatisfy { $0.remainingTime == 0 }
    }
}

