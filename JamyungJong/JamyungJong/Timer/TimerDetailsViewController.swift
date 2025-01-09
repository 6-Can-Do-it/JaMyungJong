//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit

final class TimerDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var recentTimers: [(hours: Int, minutes: Int, seconds: Int)] = []
    var selectedTime: (hours: Int, minutes: Int, seconds: Int)?
    
    private var countdownTimer: Timer?
    private var remainingTime: Int = 0
    private var isTimerRunning = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = MainColor.aliceColor
        return label
    }()
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TimerCell.self, forCellReuseIdentifier: "TimerCell") // TimerCell 등록
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: "RecentTimerCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startCountdown()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        [titleLabel, tableView].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Timer Logic
    private func startCountdown() {
        guard let time = selectedTime else { return }
        remainingTime = (time.hours * 3600) + (time.minutes * 60) + time.seconds
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            stopCountdown()
            showAlert(title: "타이머 종료", message: "현재 타이머가 종료되었습니다.")
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource
extension TimerDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : recentTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 첫 번째 섹션에서 TimerCell 사용
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell
            let hours = remainingTime / 3600
            let minutes = (remainingTime % 3600) / 60
            let seconds = remainingTime % 60
            let progress = selectedTime != nil ? Float(remainingTime) / Float((selectedTime!.hours * 3600) + (selectedTime!.minutes * 60) + selectedTime!.seconds) : 0.0
            cell.configure(hours: hours, minutes: minutes, seconds: seconds, progress: progress)
            return cell
        } else {
            // 두 번째 섹션에서 RecentTimerCell 사용
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTimerCell", for: indexPath) as! RecentTimerCell
            let timer = recentTimers[indexPath.row]
            cell.configure(hours: timer.hours, minutes: timer.minutes, seconds: timer.seconds)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        return createHeaderView(title: "최근 항목")
    }
    
    private func createHeaderView(title: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let label = UILabel()
        label.text = "최근 항목"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = MainColor.aliceColor
        
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
}

