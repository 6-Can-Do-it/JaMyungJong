//
//  AlarmListCell.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/12/25.
//

import Foundation
import UIKit


class AlarmCell: UITableViewCell {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 55)
        return label
    }()
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var uiView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .darkGray
        view.addSubview(timeLabel)
        view.addSubview(repeatLabel)
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        [uiView].forEach { contentView.addSubview($0) }
        
        uiView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.bottom.equalTo(contentView).inset(5)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(16)
        }
        
        repeatLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(timeLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(with alarm: AlarmData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        timeLabel.text = dateFormatter.string(from: alarm.time)
        
        // 반복 요일 텍스트 설정
        repeatLabel.text = createRepeatLabel(from: alarm.repeatDays)
    }
    
    private func createRepeatLabel(from days: [Bool]) -> String {
        let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
        let selectedCount = days.filter { $0 }.count
        
        if selectedCount == 0 {
            return "반복 안함"
        } else if selectedCount == 7 {
            return "매일"
        } else if days[1...5].allSatisfy({ $0 }) && !days[0] && !days[6] {
            return "주중"
        } else if days[0] && days[6] && days[1...5].allSatisfy({ !$0 }) {
            return "주말"
        } else {
            return days.enumerated()
                .filter { $0.element }
                .map { dayNames[$0.offset] }
                .joined(separator: ", ")
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: AlarmListViewController())
}
