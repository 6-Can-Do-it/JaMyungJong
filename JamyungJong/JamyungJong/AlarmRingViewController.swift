//
//  AlarmRingViewController.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/13/25.
//
//
//  AlarmRingViewController.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/13/25.
//

//
//  AlarmRingViewController.swift
//  JamyungJong
//
//
//  AlarmRingViewController.swift
//  JamyungJong
//

import UIKit
import SnapKit
import AVFoundation

class AlarmRingViewController: UIViewController {
    // MARK: - UI Elements
    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private let missionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("미션 시작", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    // MARK: - Audio Player
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCurrentTime()
        setupActions()
        playAlarmSound() // 알람 소리 재생
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(currentTimeLabel)
        view.addSubview(missionButton)
        
        // 현재 시간 및 날짜
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.centerX.equalToSuperview()
        }
        
        // 미션 시작 버튼
        missionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func setupCurrentTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE\na h:mm" // "1월 10일 수요일\n오전 12:34" 형식
        let currentDate = Date()
        currentTimeLabel.text = dateFormatter.string(from: currentDate)
    }
    
    private func setupActions() {
        missionButton.addTarget(self, action: #selector(didTapMissionButton), for: .touchUpInside)
    }
    
    // MARK: - Audio Playback
    private func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "default_ringtone", withExtension: "mp3") else {
            print("알람 사운드 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 무한 반복
            audioPlayer?.play()
        } catch {
            print("오디오 재생 오류: \(error.localizedDescription)")
        }
    }
    
    private func stopAlarmSound() {
        audioPlayer?.stop()
    }
    
    // MARK: - Actions
    @objc private func didTapMissionButton() {
        stopAlarmSound() // 미션 시작 시 알람 소리 정지
        let missionVC = MissionViewController()
        navigationController?.pushViewController(missionVC, animated: true)
    }
    private func goToMissionViewController() {
        
    }
}

