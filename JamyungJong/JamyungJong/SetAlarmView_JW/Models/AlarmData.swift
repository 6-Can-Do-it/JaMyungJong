//
//  AlarmData.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/12/25.
//

import Foundation

// 알람 데이터 모델
//JSON형 으로 변환하기 위한 Codable 채택
struct AlarmData: Codable {
    let time: Date
    let repeatDays: [Bool]
    let isEnabled: Bool
    let sound: String
    let label: String
}
