//
//  StopWatchModel.swift
//  JamyungJong
//
//  Created by 네모 on 1/9/25.
//

import Foundation

class StopWatchModel {
    private var timer: Timer?
    private(set) var isRunning = false
    private var startTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private(set) var lapTimes: [TimeInterval] = []

    var timeUpdated: ((TimeInterval) -> Void)?

    func start() {
        isRunning = true
        startTime = Date().timeIntervalSinceReferenceDate - elapsedTime
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime = Date().timeIntervalSinceReferenceDate - self.startTime
            self.timeUpdated?(self.elapsedTime)
        }
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
    }

    func reset() {
        stop()
        elapsedTime = 0
        lapTimes = []
        timeUpdated?(elapsedTime)
    }

    func recordLap() {
        lapTimes.insert(elapsedTime, at: 0)
    }
}
