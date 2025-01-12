//
//  StopWatchView.swift
//  JamyungJong
//
//  Created by 네모 on 1/9/25.
//

import UIKit
import SnapKit

class StopWatchView: UIView {

    // MARK: - UI Elements
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00.00"
        label.font = .monospacedDigitSystemFont(ofSize: 72, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    let lapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("랩", for: .normal)
        button.backgroundColor = .darkGray
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.backgroundColor = SubColor.dogerBlue
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    let lapTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    // MARK: - Initializer
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

        addSubview(timeLabel)
        addSubview(lapButton)
        addSubview(startStopButton)
        addSubview(separatorLine)
        addSubview(lapTableView)

        // Layout using SnapKit
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        let buttonSize: CGFloat = 80
        lapButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(timeLabel.snp.bottom).offset(40)
            make.width.height.equalTo(buttonSize)
        }
        lapButton.layer.cornerRadius = buttonSize / 2

        startStopButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(40)
            make.top.equalTo(timeLabel.snp.bottom).offset(40)
            make.width.height.equalTo(buttonSize)
        }
        startStopButton.layer.cornerRadius = buttonSize / 2

        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(lapButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }

        lapTableView.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
        }
    }
}
