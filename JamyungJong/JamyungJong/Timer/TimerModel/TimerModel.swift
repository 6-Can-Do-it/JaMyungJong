//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import Foundation

struct TimerModel {
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    var remainingTime: Int {
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    var countdownTimer: Timer? = nil
}
