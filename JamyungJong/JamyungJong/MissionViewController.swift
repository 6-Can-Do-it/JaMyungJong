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

       
    }
}