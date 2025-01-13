//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit

final class RecentTimerCell: UITableViewCell {
    
    // MARK: - UI Components
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .lightGray
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.backgroundColor = SubColor.dogerBlue
        button.tintColor = MainColor.aliceColor
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let separatorView: UIView = {
           let view = UIView()
           view.backgroundColor = .darkGray
           return view
       }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        backgroundColor = .clear
        
        // UI 구성
        [mainLabel, subLabel, playButton, separatorView].forEach { contentView.addSubview($0) }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(mainLabel)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(60)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Configuration
    func configure(hours: Int, minutes: Int, seconds: Int) {
        mainLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        subLabel.text = "\(hours)시간 \(minutes)분 \(seconds)초"
    }
}
