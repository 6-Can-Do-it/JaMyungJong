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
    private let questionLabel = UILabel() // 문제 표시 레이블
    private var inputLabel = UILabel() // 사용자 입력 값 표시
    private let verticalStackView = UIStackView()
    
    private var currentQuestionIndex = 0
    private var questions: [Question] = [] // 모델에서 받아오는 문제 리스트
    private var userAnswer: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        generateQuestions() // 문제 생성
        loadQuestion()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // 네비게이션 바 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "<",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        // Progress Label
        progressLabel.textColor = .white
        progressLabel.font = .systemFont(ofSize: 18, weight: .medium)
        progressLabel.textAlignment = .center
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // Question Label
        questionLabel.textColor = .white
        questionLabel.font = .boldSystemFont(ofSize: 48)
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(100)
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
            make.top.equalTo(questionLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        // Button Stack View
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(inputLabel.snp.bottom).offset(150)
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
                    button.tag = -1
                    button.backgroundColor = .systemGreen
                } else if row == 1 && col == 3 { // 정답 제출 버튼
                    button.setTitle("✔︎", for: .normal)
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
    
    private func generateQuestions() {
        questions = QuestionGenerator.generateRandomQuestions(count: 3) // 임의의 문제 3개 생성
    }
    
    private func loadQuestion() {
        guard currentQuestionIndex < questions.count else {
            showCompletionScreen()
            return
        }
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
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
        guard let answer = Int(userAnswer) else { return }
        
        if answer == questions[currentQuestionIndex].answer {
            // 정답 처리
            inputLabel.text = "O      \(userAnswer)"
            inputLabel.backgroundColor = .green
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentQuestionIndex += 1
                self.loadQuestion()
            }
        } else {
            // 오답 처리
            inputLabel.text = "X       \(userAnswer)"
            inputLabel.backgroundColor = .red
            
            // 0.5초 후 초기화하고 다시 입력 가능 상태로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.userAnswer = "" // 사용자 입력 초기화
                self.inputLabel.text = "" // 입력 필드 초기화
                self.inputLabel.backgroundColor = .darkGray // 배경색 초기화
            }
        }
    }
    
    private func showCompletionScreen() {
        questionLabel.isHidden = true
        progressLabel.isHidden = true
        inputLabel.isHidden = true
        verticalStackView.isHidden = true
        
        // 이모티콘 이미지 추가
        let emojiImageView = UIImageView()
        emojiImageView.contentMode = .scaleAspectFit
        view.addSubview(emojiImageView)
        emojiImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.width.height.equalTo(400)
        }
        
        // 메시지 레이블 추가
        let messageLabel = UILabel()
        messageLabel.textColor = .white
        messageLabel.font = .boldSystemFont(ofSize: 32)
        messageLabel.textAlignment = .center
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiImageView.snp.bottom).offset(20)
        }
        
        // 초기 화면 (참 잘했어요!)
        emojiImageView.image = UIImage(named: "ddaBong")
        messageLabel.text = "참 잘했어요!"
        
        // 2초 후 변경 (오늘 아침도 활기차게!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            emojiImageView.image = UIImage(named: "sun")
            messageLabel.text = "오늘 아침도 활기차게!"
            
            // 1초 후 MorningViewController로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.goToMorningViewController()
            }
        }
    }
    
    private func goToMorningViewController() {
        let morningVC = TabBarController()
        
        // 원하는 탭 인덱스 설정 (예: 인덱스 1번)
        morningVC.selectedIndex = 1
        
        // 네비게이션 컨트롤러를 통해 화면 이동
        navigationController?.pushViewController(morningVC, animated: true)
        //present(morningVC, animated: true, completion: nil)
    }
    
    @objc private func goBack() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1 // 이전 문제로 돌아감
            loadQuestion()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
