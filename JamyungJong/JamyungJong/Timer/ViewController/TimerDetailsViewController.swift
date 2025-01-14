//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit
import UserNotifications
import CoreData

final class TimerDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private let timerDetailsView = TimerDetailsView()
    
    var recentTimers: [(hours: Int, minutes: Int, seconds: Int, soundName: String)] = []
    var presentTimers: [(hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?, soundName: String)] = []
    private var isTimerRunning = false
    private var isEditingMode: Bool = false
    private var selectedRows: [IndexPath] = []
    
    override func loadView() {
        view = timerDetailsView
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.timerDetailsView.tableView.reloadData()
            self.startCountdown(for: 0)
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
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .black
        timerDetailsView.tableView.dataSource = self
        timerDetailsView.tableView.delegate = self
        
    }
    
    @objc func editButtonTapped() {
        isEditingMode.toggle()
        selectedRows.removeAll() // 기존 선택 상태 초기화
        timerDetailsView.tableView.setEditing(isEditingMode, animated: true)

        if isEditingMode {
            navigationItem.leftBarButtonItem?.title = "완료"
        } else {
            deleteSelectedRows() // 완료 버튼 클릭 시 선택된 항목 삭제
            navigationItem.leftBarButtonItem?.title = "편집"
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func deleteSelectedRows() {
        // 선택된 셀들 삭제
        let rowsToDelete = selectedRows.sorted(by: { $0.row > $1.row }) // 역순으로 정렬
        for indexPath in rowsToDelete {
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
            
            recentTimers.remove(at: indexPath.row)
        }
        
        timerDetailsView.tableView.deleteRows(at: rowsToDelete, with: .automatic)
        selectedRows.removeAll()
    }
    
    private func startCountdown(for index: Int) {
        // 타이머에 해당하는 remainingTime 초기화
        var timer = presentTimers[index]
        
        // 남은 시간이 0이라면 초기화
        if timer.remainingTime == 0 {
            timer.remainingTime = (timer.hours * 3600) + (timer.minutes * 60) + timer.seconds
        }

        // 타이머가 실행 중이지 않으면 타이머 시작
        guard timer.countdownTimer == nil else { return }
        NotificationManager.shared.scheduleNotification(withSoundName: timer.soundName, after: TimeInterval(timer.remainingTime))
        // 개별 타이머의 countdownTimer 설정
        timer.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown(for: index)
        }

        // presentTimers 배열에 업데이트된 타이머 저장
        presentTimers[index] = timer
    }

    private func updateCountdown(for index: Int) {
        var timer = presentTimers[index]
        
        if timer.remainingTime > 0 {
            timer.remainingTime -= 1
            presentTimers[index] = timer  // 배열에 업데이트된 타이머 저장
            DispatchQueue.main.async { [weak self] in
                self?.timerDetailsView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        } else {
            stopCountdown(for: index)
            //NotificationManager.shared.scheduleNotification(withSoundName: timer.soundName)
            // 모든 타이머가 종료되었는지 확인
            if areAllTimersFinished() {
                // 타이머 셀 초기화
                presentTimers.removeAll()
                DispatchQueue.main.async { [weak self] in
                    self?.timerDetailsView.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
                }
                navigationController?.popViewController(animated: true)
            }
        }
    }

    // 모든 타이머가 종료되었는지 확인하는 함수
    private func areAllTimersFinished() -> Bool {
        return presentTimers.allSatisfy { $0.remainingTime == 0 }
    }

    private func stopCountdown(for index: Int) {
        var timer = presentTimers[index]
        timer.countdownTimer?.invalidate() // 타이머 멈추기
        timer.countdownTimer = nil // 타이머 해제
        presentTimers[index] = timer  // 배열에 업데이트된 타이머 저장
    }

    private func toggleCountdown(for index: Int) {
        if presentTimers[index].countdownTimer == nil {
            startCountdown(for: index) // 타이머 시작
        } else {
            stopCountdown(for: index) // 타이머 정지
        }
    }
    
}

extension TimerDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? presentTimers.count : recentTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return configureTimerCell(for: indexPath, in: tableView)
        } else {
            return configureRecentTimerCell(for: indexPath, in: tableView)
        }
    }
    
    // TimerCell 구성
    private func configureTimerCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell
        let timer = presentTimers[indexPath.row]
        
        // 시간 계산
        let hours = timer.remainingTime / 3600
        let minutes = (timer.remainingTime % 3600) / 60
        let seconds = timer.remainingTime % 60
        let totalDuration = (timer.hours * 3600) + (timer.minutes * 60) + timer.seconds
        let progress = Float(timer.remainingTime) / Float(totalDuration)
        
        // 셀 구성
        cell.configure(hours: hours, minutes: minutes, seconds: seconds, progress: progress)
        
        // toggleTimer 클로저 연결
        cell.toggleTimer = { [weak self] in
            self?.toggleCountdown(for: indexPath.row)
        }
        
        return cell
    }
    
    // RecentTimerCell 구성
    private func configureRecentTimerCell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTimerCell", for: indexPath) as! RecentTimerCell
        let timer = recentTimers[indexPath.row]
        
        // 셀 구성
        cell.configure(hours: timer.hours, minutes: timer.minutes, seconds: timer.seconds)
        
        // playButton 액션 추가
        cell.playButton.tag = indexPath.row
        cell.playButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.playButton.addAction(UIAction { [weak self] _ in
            self?.handlePlayButtonTapped(for: indexPath.row)
        }, for: .touchUpInside)
        
        return cell
    }

    // playButton 액션 처리
    private func handlePlayButtonTapped(for index: Int) {
        let selectedTimer = recentTimers[index]
        
        // 새 타이머 추가
        presentTimers.append((
            hours: selectedTimer.hours,
            minutes: selectedTimer.minutes,
            seconds: selectedTimer.seconds,
            remainingTime: (selectedTimer.hours * 3600) + (selectedTimer.minutes * 60) + selectedTimer.seconds,
            soundName: selectedTimer.soundName , countdownTimer: nil
        ))
        
        // 테이블 뷰 업데이트
        let indexPathForNewTimer = IndexPath(row: presentTimers.count - 1, section: 0)
        timerDetailsView.tableView.insertRows(at: [indexPathForNewTimer], with: .automatic)
        
        // 타이머 시작
        startCountdown(for: presentTimers.count - 1)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 { // 현재 타이머 삭제
                stopCountdown(for: indexPath.row) // 타이머 멈추기
                presentTimers.remove(at: indexPath.row) // 데이터 소스에서 삭제
            } else { // 최근 타이머 삭제
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
                
                recentTimers.remove(at: indexPath.row) // 데이터 소스에서 삭제
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic) // 테이블 뷰에서 삭제
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingMode {
            selectedRows.append(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isEditingMode {
            selectedRows.removeAll { $0 == indexPath }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : UITableView.automaticDimension
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
