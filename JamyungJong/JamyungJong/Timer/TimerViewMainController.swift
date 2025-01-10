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
    private var presentTimers: [(hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)] = []
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
    
    override func viewDidAppear(_ animated: Bool) {
        countdownTimer = nil
        isTimerRunning = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerView.recentTimersTableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let editButton = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        editButton.setTitleTextAttributes([.foregroundColor: SubColor.dogerBlue], for: .normal)
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
    
    @objc func editButtonTapped() {
        
    }
    
    private func cancelTapped() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingTime = 0
        isTimerRunning = false
    }
    
    private func startTapped() {
        if isTimerRunning { return }

        let newTimer = TimerModel(hours: selectedTime.hours, minutes: selectedTime.minutes, seconds: selectedTime.seconds)
        presentTimers.append((newTimer.hours, newTimer.minutes, newTimer.seconds, newTimer.remainingTime, nil))
        recentTimers.insert(selectedTime, at: 0)

        let detailsVC = TimerDetailsViewController()
        detailsVC.recentTimers = recentTimers
        detailsVC.presentTimers = presentTimers
        navigationController?.pushViewController(detailsVC, animated: false)
        presentTimers.removeAll()
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
        
        if let text = timerView.value1.text, !text.isEmpty {
            cell.subLabel.text = text
        } else {
            cell.configure(hours: timer.hours, minutes: timer.minutes, seconds: timer.seconds)
        }
        
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
