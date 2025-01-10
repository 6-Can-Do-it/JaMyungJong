//
//  Constants.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/7/25.
//

import UIKit

//MARK: - 기타 색상
public enum SubColor {
    static let dogerBlue = UIColor(hexCode: "#1E90FF") //청색 - 밝고 활기찬 느낌의 청색
    static let navy = UIColor(hexCode: "#000080") //짙은 청색 - 안정감과 세련됨을 더해줄 짙은 청색
    static let darkTurquoisePoint = UIColor(hexCode: "#00CED1") //포인트 색상 - 뱀의 신비로움을 강조할 수 있는 청록색
    static let textPlaceholderColor = UIColor(hexCode: "#7699A8") // 텍스트필드 텍스트플레이스홀더 색상
}

//MARK: - 배경 및 보조 색상
public enum MainColor {
    static let skyColor = UIColor(hexCode: "#87CEEB") //밝은청색 - 부드러운 배경 색상
    static let aliceColor = UIColor(hexCode: "#F0F8FF") //연회색 - 차분한 인터페이스를 위한 색상
    static let goldPoint = UIColor(hexCode: "#FFD700") //골드 포인트 - 뱀의 고급스러운 이미지를 위한 포인트
}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

