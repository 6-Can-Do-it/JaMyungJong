//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit

final class TimerView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이머"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = MainColor.aliceColor
        return label
    }()
    
    let timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .clear
        return picker
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .darkGray
        button.tintColor = MainColor.aliceColor
        button.layer.cornerRadius = 40
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("시작", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = SubColor.dogerBlue
        button.tintColor = MainColor.aliceColor
        button.layer.cornerRadius = 40
        return button
    }()
    
    let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .darkGray
        container.layer.cornerRadius = 10
        return container
    }()

    let recentTimersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecentTimerCell.self, forCellReuseIdentifier: "RecentTimerCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorColor = .gray
        return tableView
    }()

    private let label1: UILabel = {
        let label = UILabel()
        label.text = "레이블"
        label.textColor = MainColor.aliceColor
        return label
    }()

    let value1: UITextField = {
        let textField = UITextField()
        
        let placeholderText = "타이머"
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: SubColor.textPlaceholderColor
            ]
        )
        textField.backgroundColor = .clear
        textField.textColor = SubColor.darkTurquoisePoint
        textField.textAlignment = .right
        return textField
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "타이머 종료 시"
        label.textColor = MainColor.aliceColor
        return label
    }()

    let value2: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Arpeggio"
        configuration.baseForegroundColor = SubColor.darkTurquoisePoint
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = UIFont.systemFont(ofSize: 17)
            return attributes
        }
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .right
        return button
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .black
        [titleLabel, timePicker, cancelButton, startButton, containerView, recentTimersTableView].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
        }
        
        timePicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(150)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(40)
            make.width.height.equalTo(80)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(timePicker.snp.bottom).offset(24)
            make.right.equalToSuperview().offset(-40)
            make.width.height.equalTo(80)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(115)
        }
        
        [label1, value1, separatorView, label2, value2].forEach{ containerView.addSubview($0) }

        label1.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
    
        }
        
        value1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
        }

        separatorView.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        label2.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(18)
        }

        value2.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(18)
            make.right.equalToSuperview().offset(-18)
        }
        
        recentTimersTableView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview().inset(20)
        }
    }
}
