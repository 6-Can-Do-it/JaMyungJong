//
//  MissionViewController.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/9/25.
//

import Foundation
import UIKit
import SnapKit

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
        setupUI()
    }
    private func setupUI() {
        view.backgroundColor = .black
        
        // Back Button
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
        }
        
        // Progress Label
        progressLabel.textColor = .white
        progressLabel.font = .systemFont(ofSize: 16, weight: .medium)
        progressLabel.textAlignment = .center
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        // Question Label
        questionLabel.textColor = .white
        questionLabel.font = .boldSystemFont(ofSize: 32)
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Input Label
        inputLabel.textColor = .white
        inputLabel.font = .boldSystemFont(ofSize: 28)
        inputLabel.textAlignment = .center
        inputLabel.backgroundColor = .darkGray
        inputLabel.layer.cornerRadius = 8
        inputLabel.clipsToBounds = true
        view.addSubview(inputLabel)
        inputLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        // Button Container
        view.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(400) // 컨테이너 높이 확장
        }
        
        setupButtons()
    }
    
    private func setupButtons() {
        let rows = 4
        let cols = 4
        let spacing: CGFloat = 10
        let buttonSize = (UIScreen.main.bounds.width - CGFloat((cols + 1) * Int(spacing))) / CGFloat(cols)
        
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9] // 1~9 숫자 버튼
        var numberIndex = 0
        
        for row in 0..<rows {
            for col in 0..<cols {
                let button = UIButton(type: .system)
                button.setTitleColor(.white, for: .normal)
                button.layer.cornerRadius = 8
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                // Clear 버튼 (✕), 제출 버튼 (✔︎), 숫자 0
                if row == 0 && col == 3 {   //클리어 버튼
                    button.setTitle("✕", for: .normal)
                    button.tintColor = .black
                    button.tag = -1
                    button.backgroundColor = .systemGreen
                    
                } else if row == 1 && col == 3 {    //정답 제출 버튼
                    button.setTitle("✔︎", for: .normal)
                    button.tintColor = .black
                    button.tag = 0
                    button.backgroundColor = .systemGreen
                } else if row == 2 && col == 3 {
                    button.setTitle("0", for: .normal)
                    button.tag = 0
                    button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0) // Dodger Blue
                } else if numberIndex < numbers.count { // 1~9 숫자 버튼 생성
                    let number = numbers[numberIndex]
                    button.setTitle("\(number)", for: .normal)
                    button.tag = number
                    numberIndex += 1
                    button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0) // Dodger Blue
                } else {
                    button.isHidden = true // 필요 없는 버튼 숨김 처리
                }
                
                buttonContainer.addSubview(button)
                
                // SnapKit 레이아웃 설정
                button.snp.makeConstraints { make in
                    make.width.height.equalTo(buttonSize)
                    make.left.equalTo(buttonContainer).offset(CGFloat(col) * (buttonSize + spacing))
                    make.top.equalTo(buttonContainer).offset(CGFloat(row) * (buttonSize + spacing))
                }
            }
        }
    }
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender.tag == -1 { // Clear 버튼
            userAnswer = ""
            inputLabel.text = userAnswer
        } else if sender.tag == 0 && sender.currentTitle == "✔︎" { // 제출 버튼
            submitAnswer()
        } else if sender.currentTitle != "✔︎" { // 숫자 버튼
            if userAnswer.count < 2 {
                userAnswer.append("\(sender.tag)")
                inputLabel.text = userAnswer
            }
        }
    }
    private func submitAnswer() {
        guard let answer = Int(userAnswer), answer == answers[currentQuestionIndex] else {
            // 오답 처리
            inputLabel.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.inputLabel.backgroundColor = .darkGray
            }
            return
        }
    }
}
