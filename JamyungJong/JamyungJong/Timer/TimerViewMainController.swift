//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit

final class TimerViewMainController: UIViewController {
    
    private let timerView = TimerView()
    private var recentTimers: [(hours: Int, minutes: Int, seconds: Int)] = []
    private var selectedTime: (hours: Int, minutes: Int, seconds: Int) = (0, 0, 0)
    private var countdownTimer: Timer?
    private var remainingTime: Int = 0
    private var isTimerRunning = false

    override func loadView() {
        view = timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        setupActions()
        setupNavigationBar()
        timerView.recentTimersTableView.dataSource = self
        timerView.recentTimersTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: nil,
            action: nil
        )
        editButton.setTitleTextAttributes([.foregroundColor: SubColor.dogerBlue], for: .normal)
        navigationItem.title = "편집"
        navigationItem.leftBarButtonItem = editButton
    }
    
    private func setupPickerView() {
        timerView.timePicker.delegate = self
        timerView.timePicker.dataSource = self
        
        timerView.timePicker.selectRow(0, inComponent: 0, animated: false)
        timerView.timePicker.selectRow(0, inComponent: 1, animated: false)
        timerView.timePicker.selectRow(0, inComponent: 2, animated: false)
    }
    
    private func setupActions() {
        timerView.cancelButton.addAction(UIAction { [weak self] _ in
            self?.cancelTapped()
        }, for: .touchUpInside)
        
        timerView.startButton.addAction(UIAction { [weak self] _ in
            self?.startTapped()
        }, for: .touchUpInside)
    }
    
    private func cancelTapped() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 0
        isTimerRunning = false
    }
    
    private func startTapped() {
        if isTimerRunning { return }
        
        remainingTime = (selectedTime.hours * 3600) + (selectedTime.minutes * 60) + selectedTime.seconds
        recentTimers.insert(selectedTime, at: 0)
        timerView.recentTimersTableView.reloadData()
        
        isTimerRunning = true
        
        let detailsVC = TimerDetailsViewController()
        detailsVC.recentTimers = recentTimers
        detailsVC.selectedTime = selectedTime
        navigationController?.pushViewController(detailsVC, animated: false)
        
        startCountdown()
    }
    
    private func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            let hours = remainingTime / 3600
            let minutes = (remainingTime % 3600) / 60
            let seconds = remainingTime % 60
            print("Remaining Time: \(hours):\(minutes):\(seconds)")
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            isTimerRunning = false
            timerView.timePicker.isHidden = false
            timerView.containerView.isHidden = false
            print("Timer finished!")
        }
    }
}

extension TimerViewMainController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 24 : 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = String(row)
        return NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedTime.hours = row
        } else if component == 1 {
            selectedTime.minutes = row
        } else {
            selectedTime.seconds = row
        }
    }
}

extension TimerViewMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTimerCell", for: indexPath) as! RecentTimerCell
        let timer = recentTimers[indexPath.row]
        cell.mainLabel.text = String(format: "%d:%02d:%02d", timer.hours, timer.minutes, timer.seconds)
        cell.subLabel.text = "\(timer.hours)시간 \(timer.minutes)분 \(timer.seconds)초"
        cell.playButton.tag = indexPath.row
        cell.playButton.addAction(UIAction { [weak self] _ in
            let selectedTimer = self?.recentTimers[cell.playButton.tag]
            self?.selectedTime = selectedTimer!
            self?.startTapped()
        }, for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !recentTimers.isEmpty else { return nil }
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
