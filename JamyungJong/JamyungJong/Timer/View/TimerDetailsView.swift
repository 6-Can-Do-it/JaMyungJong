//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import UIKit
import SnapKit

final class TimerDetailsView: UIView {

    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = MainColor.aliceColor
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TimerCell.self, forCellReuseIdentifier: "TimerCell")
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: "RecentTimerCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .black
        addSubview(titleLabel)
        addSubview(tableView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
