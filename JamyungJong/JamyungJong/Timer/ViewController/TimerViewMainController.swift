//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit
import CoreData

final class TimerViewMainController: UIViewController {
    
    private let timerView = TimerView()
    private var recentTimers: [(hours: Int, minutes: Int, seconds: Int, soundName: String)] = []
    private var selectedTime: (hours: Int, minutes: Int, seconds: Int, soundName: String) = (0, 0, 0, "")
    var presentTimers: [(hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?, soundName: String)] = []
    private var countdownTimer: Timer?
    private var remainingTime: Int = 0
    private var selectedSound: String = "Arpeggio"
    private var isTimerRunning = false

    override func loadView() {
        view = timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataManager.shared.loadRecentTimers()
        recentTimers = CoreDataManager.shared.recentTimers
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
        if let lastSelectedTimer = recentTimers.first {
            timerView.timePicker.selectRow(lastSelectedTimer.hours, inComponent: 0, animated: true)
            timerView.timePicker.selectRow(lastSelectedTimer.minutes, inComponent: 1, animated: true)
            timerView.timePicker.selectRow(lastSelectedTimer.seconds, inComponent: 2, animated: true)
            
            selectedTime = lastSelectedTimer // 선택된 타이머 값 갱신
        }
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
        
        timerView.value2.addTarget(self, action: #selector(value2ButtonTapped), for: .touchUpInside)
    }
    
    @objc private func value2ButtonTapped() {
        let soundSelectionVC = SoundSelectionViewController()
        soundSelectionVC.selectedSound = selectedSound
        soundSelectionVC.delegate = self

        let navController = UINavigationController(rootViewController: soundSelectionVC)
        navController.modalPresentationStyle = .formSheet
        present(navController, animated: true)
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
        // `presentTimers`에 새 타이머 추가 (소리 포함)
        presentTimers.append((newTimer.hours, newTimer.minutes, newTimer.seconds, newTimer.remainingTime, nil, selectedSound))
        
        // `recentTimers`에 새 타이머 추가 (소리 포함)
        recentTimers.insert((selectedTime.hours, selectedTime.minutes, selectedTime.seconds, selectedSound), at: 0)
        CoreDataManager.shared.saveRecentTimer((selectedTime.hours, selectedTime.minutes, selectedTime.seconds, selectedSound))

        let detailsVC = TimerDetailsViewController()
        detailsVC.recentTimers = recentTimers
        detailsVC.presentTimers = presentTimers
        navigationController?.pushViewController(detailsVC, animated: true)
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

        cell.configure(hours: timer.hours, minutes: timer.minutes, seconds: timer.seconds)

        cell.playButton.tag = indexPath.row
        cell.playButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.playButton.addAction(UIAction { [weak self] _ in
            let selectedTimer = self?.recentTimers[cell.playButton.tag]
            self?.selectedTime = (selectedTimer?.hours ?? 0, selectedTimer?.minutes ?? 0, selectedTimer?.seconds ?? 0, selectedTimer?.soundName ?? "")
            self?.selectedSound = selectedTimer?.soundName ?? "default"
            self?.startTapped()
        }, for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data에서 삭제할 엔티티 찾기
            let timerToDelete = recentTimers[indexPath.row]
            let context = CoreDataManager.shared.context
            let fetchRequest: NSFetchRequest<RecentTimerEntities> = RecentTimerEntities.fetchRequest()

            do {
                let timers = try context.fetch(fetchRequest)
                if let entityToDelete = timers.first(where: {
                    Int($0.hours) == timerToDelete.hours &&
                    Int($0.minutes) == timerToDelete.minutes &&
                    Int($0.seconds) == timerToDelete.seconds
                }) {
                    CoreDataManager.shared.deleteRecentTimer(entityToDelete)
                }
            } catch {
                print("Failed to delete timer: \(error)")
            }

            // 데이터 소스에서 삭제
            recentTimers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
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

extension TimerViewMainController: SoundSelectionDelegate {
    func didSelectSound(_ sound: String) {
        selectedSound = sound
        timerView.value2.setTitle(sound, for: .normal)
        
        // 현재 타이머에 소리 업데이트
        if let currentTimerIndex = presentTimers.firstIndex(where: { $0.remainingTime == remainingTime }) {
            presentTimers[currentTimerIndex].soundName = sound
        }
        
        // 최근 타이머에도 소리 업데이트
        if let recentTimerIndex = recentTimers.firstIndex(where: {
            $0.hours == selectedTime.hours &&
            $0.minutes == selectedTime.minutes &&
            $0.seconds == selectedTime.seconds
        }) {
            recentTimers[recentTimerIndex].soundName = sound
        }
    }
}
