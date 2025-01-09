//
//  MissionViewController.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/9/25.
//

import UIKit
import SnapKit
class MissionViewController: UIViewController {
  private let progressLabel = UILabel() // Progress (1/3)
  private let questionLabel = UILabel() // 문제 표시 (9 + 5)
  private var inputLabel = UILabel() // 사용자 입력 값 표시
  private let backButton = UIButton() // 뒤로 가기 버튼
  private let verticalStackView = UIStackView()
  private var currentQuestionIndex = 0
  private let questions = ["9 + 5", "5 + 6", "11 + 3"]
  private let answers = [14, 11, 14]
  private var userAnswer: String = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    loadQuestion()
  }
  private func setupUI() {
    view.backgroundColor = .black
    // Back Button
    backButton.setTitle("<", for: .normal)
    backButton.setTitleColor(.white, for: .normal)
    backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    view.addSubview(backButton)
    backButton.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      make.leading.equalToSuperview().offset(10)
      make.width.height.equalTo(40)
    }
    // Progress Label
    progressLabel.textColor = .white
    progressLabel.font = .systemFont(ofSize: 18, weight: .medium)
    progressLabel.textAlignment = .center
    view.addSubview(progressLabel)
    progressLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalTo(backButton)
    }
    // Question Label
    questionLabel.textColor = .white
    questionLabel.font = .boldSystemFont(ofSize: 48)
    questionLabel.textAlignment = .center
    view.addSubview(questionLabel)
    questionLabel.snp.makeConstraints { make in
      make.top.equalTo(progressLabel.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
    // Input Label
    inputLabel.textColor = .white
    inputLabel.font = .boldSystemFont(ofSize: 36)
    inputLabel.textAlignment = .center
    inputLabel.backgroundColor = .darkGray
    inputLabel.layer.cornerRadius = 8
    inputLabel.clipsToBounds = true
    view.addSubview(inputLabel)
    inputLabel.snp.makeConstraints { make in
      make.top.equalTo(questionLabel.snp.bottom).offset(30)
      make.centerX.equalToSuperview()
      make.width.equalTo(120)
      make.height.equalTo(60)
    }
    // Button Stack View
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 10
    verticalStackView.distribution = .fillEqually
    view.addSubview(verticalStackView)
    verticalStackView.snp.makeConstraints { make in
      make.top.equalTo(inputLabel.snp.bottom).offset(40)
      make.centerX.equalToSuperview()
      make.width.equalTo(350)
      make.height.equalTo(350)
    }
    setupButtons()
  }
  private func setupButtons() {
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var numberIndex = 0
    for row in 0..<4 {
      let horizontalStackView = UIStackView()
      horizontalStackView.axis = .horizontal
      horizontalStackView.spacing = 10
      horizontalStackView.distribution = .fillEqually
      for col in 0..<4 {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if row == 0 && col == 3 { // Clear 버튼
          button.setTitle("✕", for: .normal)
          button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
          button.tintColor = .black
          button.tag = -1
          button.backgroundColor = .systemGreen
        } else if row == 1 && col == 3 { // 정답 제출 버튼
          button.setTitle("✔︎", for: .normal)
          button.tintColor = .black
          button.tag = 0
          button.backgroundColor = .systemGreen
        } else if row == 2 && col == 3 { // 숫자 0
          button.setTitle("0", for: .normal)
          button.tag = 0
          button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0)
        } else if numberIndex < numbers.count {
          let number = numbers[numberIndex]
          button.setTitle("\(number)", for: .normal)
          button.tag = number
          numberIndex += 1
          button.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1.0)
        } else {
          button.isHidden = true
        }
        horizontalStackView.addArrangedSubview(button)
      }
      verticalStackView.addArrangedSubview(horizontalStackView)
    }
  }
  private func loadQuestion() {
    guard currentQuestionIndex < questions.count else {
      showCompletionScreen()
      return
    }
    questionLabel.text = questions[currentQuestionIndex]
    progressLabel.text = "\(currentQuestionIndex + 1)/\(questions.count)"
    userAnswer = ""
    inputLabel.text = ""
    inputLabel.backgroundColor = .darkGray
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
    // 정답 처리
    inputLabel.backgroundColor = .green
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.currentQuestionIndex += 1
      self.loadQuestion()
    }
  }
  private func showCompletionScreen() {
    questionLabel.isHidden = true
    progressLabel.isHidden = true
    inputLabel.isHidden = true
    verticalStackView.isHidden = true
    let completionLabel = UILabel()
    completionLabel.text = "참 잘했어요!"
    completionLabel.textColor = .white
    completionLabel.font = .boldSystemFont(ofSize: 32)
    completionLabel.textAlignment = .center
    view.addSubview(completionLabel)
    completionLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      completionLabel.text = "오늘 아침도 활기찬 하루!"
    }
  }
  @objc private func goBack() {
    dismiss(animated: true, completion: nil)
  }
}
