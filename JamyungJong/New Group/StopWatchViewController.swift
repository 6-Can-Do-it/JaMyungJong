//
//  StopWatchViewController.swift
//  JamyungJong
//
//  Created by 네모 on 1/9/25.
//

import UIKit
import SnapKit

class StopWatchViewController: UIViewController {

    // MARK: - Properties
    private var timer: Timer?
    private var isRunning: Bool = false
    private var startTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var lapTimes: [TimeInterval] = []

    // MARK: - UI Elements
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.font = .monospacedDigitSystemFont(ofSize: 72, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let lapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("랩", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.backgroundColor = SubColor.dogerBlue // Dodger Blue 색상 적용
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let lapTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()
        lapTableView.dataSource = self
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black

        view.addSubview(timeLabel)
        view.addSubview(lapButton)
        view.addSubview(startStopButton)
        view.addSubview(separatorLine)
        view.addSubview(lapTableView)

        // Layout using SnapKit
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100) // 상단 여백
            make.left.equalToSuperview().offset(20) // 좌측 여백
            make.right.equalToSuperview().inset(20) // 우측 여백
        }

        let buttonSize: CGFloat = 80 // 버튼 크기

        lapButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40) // 좌측 여백
            make.top.equalTo(timeLabel.snp.bottom).offset(40) // 버튼과 시간 간격
            make.width.height.equalTo(buttonSize)
        }
        lapButton.layer.cornerRadius = buttonSize / 2 // 동그랗게 만들기

        startStopButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(40) // 우측 여백
            make.top.equalTo(timeLabel.snp.bottom).offset(40) // 버튼과 시간 간격
            make.width.height.equalTo(buttonSize)
        }
        startStopButton.layer.cornerRadius = buttonSize / 2 // 동그랗게 만들기

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(lapButton.snp.bottom).offset(20) // 버튼과 선 간격
            make.left.right.equalToSuperview().inset(20) // 좌우 여백
            make.height.equalTo(1)
        }

        lapTableView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10) // 선과 테이블 간격
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50) // TabBar 높이를 고려하여 하단 여백 추가
        }
    }

    private func setupActions() {
        lapButton.addTarget(self, action: #selector(handleLapButton), for: .touchUpInside)
        startStopButton.addTarget(self, action: #selector(handleStartStopButton), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func handleStartStopButton() {
        if isRunning {
            stopTimer()
            startStopButton.setTitle("시작", for: .normal) // "중단" -> "시작"
            startStopButton.backgroundColor = SubColor.dogerBlue
            lapButton.setTitle("재설정", for: .normal) // "랩" -> "재설정"
            lapButton.backgroundColor = .darkGray
        } else {
            if startStopButton.title(for: .normal) == "시작" {
                startTimer()
                startStopButton.setTitle("중단", for: .normal) // "시작" -> "중단"
                startStopButton.backgroundColor = .systemRed
                lapButton.setTitle("랩", for: .normal) // "재설정" -> "랩"
                lapButton.backgroundColor = .darkGray
            }
        }
    }

    @objc private func handleLapButton() {
        if isRunning {
            recordLap() // "랩" 버튼 동작
        } else if lapButton.title(for: .normal) == "재설정" {
            resetTimer() // "재설정" 버튼 동작
        }
    }

    // MARK: - Timer Logic
    private func startTimer() {
        isRunning = true
        startTime = Date().timeIntervalSinceReferenceDate - elapsedTime

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedTime = Date().timeIntervalSinceReferenceDate - self.startTime
            self.updateTimeLabel()
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }

    private func resetTimer() {
        stopTimer()
        elapsedTime = 0
        lapTimes = []
        lapTableView.reloadData()
        updateTimeLabel()
    }

    private func recordLap() {
        lapTimes.insert(elapsedTime, at: 0)
        lapTableView.reloadData()
    }

    private func updateTimeLabel() {
        let minutes = Int(elapsedTime / 60)
        let seconds = Int(elapsedTime) % 60
        let centiseconds = Int((elapsedTime - floor(elapsedTime)) * 100)

        timeLabel.text = String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
    }
}

// MARK: - UITableViewDataSource
extension StopWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTimes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LapCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "LapCell")
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white

        // Monospaced font for consistent width
        cell.detailTextLabel?.font = .monospacedDigitSystemFont(ofSize: 16, weight: .regular)

        let lapTime = lapTimes[indexPath.row]
        let minutes = Int(lapTime / 60)
        let seconds = Int(lapTime) % 60
        let centiseconds = Int((lapTime - floor(lapTime)) * 100)

        cell.textLabel?.text = "랩 \(lapTimes.count - indexPath.row)"
        cell.detailTextLabel?.text = String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)

        return cell
    }
}
