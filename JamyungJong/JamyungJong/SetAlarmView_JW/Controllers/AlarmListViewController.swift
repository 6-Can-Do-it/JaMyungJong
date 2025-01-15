//
//  AlarmListViewController.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/12/25.
//

import UIKit

class AlarmListViewController: UIViewController {
    static var alarms: [AlarmData] = []
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.register(AlarmCell.self, forCellReuseIdentifier: "AlarmCell")
        tv.separatorStyle = .singleLine
        tv.separatorColor = .darkGray
        return tv
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = SubColor.darkTurquoisePoint
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 60)
        button.layer.borderWidth = 2.0
        button.clipsToBounds = true
        button.layer.cornerRadius = 70 / 2
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        [tableView, addButton].forEach { view.addSubview($0)}
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.height.equalTo(70)
        }
    }
    
    @objc private func addButtonTapped() {
        let setAlarmVC = SetAlarmViewController()
        navigationController?.pushViewController(setAlarmVC, animated: true)
    }
    
    func addAlarm(_ alarm: AlarmData) {
        AlarmListViewController.alarms.append(alarm)
        tableView.reloadData()
    }
}
extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AlarmListViewController.alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmCell else {
            return UITableViewCell()
        }
        let alarm = AlarmListViewController.alarms[indexPath.row]
        cell.configure(with: alarm)
        NotificationManager.shared.scheduleAlarmNotification(alarmData: alarm)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: AlarmListViewController())
}
