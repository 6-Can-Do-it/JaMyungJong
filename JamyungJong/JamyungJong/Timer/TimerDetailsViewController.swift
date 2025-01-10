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
    var presentTimers: [(hours: Int, minutes: Int, seconds: Int, remainingTime: Int, countdownTimer: Timer?)] = [
        (hours: 0, minutes: 0, seconds: 0, remainingTime: 0, countdownTimer: nil)
    ]
    
    private var isTimerRunning = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = MainColor.aliceColor
        return label
    }()
    
    // MARK: - UI Components
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TimerCell.self, forCellReuseIdentifier: "TimerCell")
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: "RecentTimerCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
        plusButton.tintColor = SubColor.dogerBlue
        navigationItem.rightBarButtonItem = plusButton
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
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func editButtonTapped() {
        
    }
    
    @objc func plusButtonTapped() {
        
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
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        } else {
            stopCountdown(for: index)
            
            // 모든 타이머가 종료되었는지 확인
            if areAllTimersFinished() {
                // 타이머 셀 초기화
                presentTimers.removeAll()
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .none)
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
            // 첫 번째 섹션에서 TimerCell 사용
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell", for: indexPath) as! TimerCell
            let timer = presentTimers[indexPath.row]
            let hours = timer.remainingTime / 3600
            let minutes = (timer.remainingTime % 3600) / 60
            let seconds = timer.remainingTime % 60
            let progress = Float(timer.remainingTime) / Float((timer.hours * 3600) + (timer.minutes * 60) + timer.seconds)
            cell.configure(hours: hours, minutes: minutes, seconds: seconds, progress: progress)
            
            // toggleTimer 클로저 연결
            cell.toggleTimer = { [weak self] in
                self?.toggleCountdown(for: indexPath.row)
            }
            return cell
        } else {
            // 두 번째 섹션에서 RecentTimerCell 사용
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTimerCell", for: indexPath) as! RecentTimerCell
            let timer = recentTimers[indexPath.row]
            cell.configure(hours: timer.hours, minutes: timer.minutes, seconds: timer.seconds)
            
            // playButton의 tag에 indexPath.row를 설정하여 해당 타이머를 선택
            cell.playButton.tag = indexPath.row
            cell.playButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.playButton.addAction(UIAction { [weak self] _ in
                guard let self = self else { return }
                
                // 최근 타이머에서 선택된 타이머 찾기
                let selectedTimer = self.recentTimers[cell.playButton.tag]
                
                // presentTimers 배열에 새 타이머 추가
                self.presentTimers.append((hours: selectedTimer.hours, minutes: selectedTimer.minutes, seconds: selectedTimer.seconds, remainingTime: (selectedTimer.hours * 3600) + (selectedTimer.minutes * 60) + selectedTimer.seconds, countdownTimer: nil))
                
                // 새로운 타이머 셀을 첫 번째 섹션에 삽입
                let indexPathForNewTimer = IndexPath(row: self.presentTimers.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPathForNewTimer], with: .automatic)
                // 타이머 시작
                self.startCountdown(for: self.presentTimers.count - 1)
            }, for: .touchUpInside)
            
            return cell
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
