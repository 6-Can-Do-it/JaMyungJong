//
//  MissionViewController.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/9/25.
//

import Foundation
import UIKit
import UIKit

class MissionViewController: UIViewController {
    private let progressLabel = UILabel() // Progress (1/3)
    private let questionLabel = UILabel() // 문제 표시 (9 + 5)
    private var inputLabel = UILabel() // 사용자 입력 값 표시
    private let backButton = UIButton() // 뒤로 가기 버튼
    private let buttonContainer = UIView() // 숫자 버튼 배열 컨테이너

    private var currentQuestionIndex = 0
    private let questions = ["9 + 5", "5 + 6", "11 + 3"]
    private let answers = [14, 11, 14]
    private var userAnswer: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
    }
}
