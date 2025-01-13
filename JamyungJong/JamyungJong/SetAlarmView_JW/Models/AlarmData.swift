//
//  AlarmData.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/12/25.
//

import Foundation

// 알람 데이터 모델
struct AlarmData {
    let time: Date
    let repeatDays: [Bool]
    let isEnabled: Bool
}
