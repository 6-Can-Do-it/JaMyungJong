//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit
import SnapKit

final class TimerCell: UITableViewCell {
    
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
    
    private let progressContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = SubColor.dogerBlue1
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = MainColor.aliceColor
        progress.trackTintColor = .clear
        progress.layer.cornerRadius = 10
        progress.clipsToBounds = true
        return progress
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = MainColor.aliceColor
        button.backgroundColor = .clear
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
        [mainLabel, subLabel, progressContainerView, separatorView].forEach { contentView.addSubview($0) }
        progressContainerView.addSubview(progressView)
        progressContainerView.addSubview(playButton)
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(8)
            make.leading.equalTo(mainLabel)
        }
        
        progressContainerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(60)
        }
        
        progressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(progressContainerView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Configuration
    func configure(hours: Int, minutes: Int, seconds: Int, progress: Float) {
        mainLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        subLabel.text = "\(hours)시간 \(minutes)분 \(seconds)초"
        progressView.progress = progress
    }
    
    // MARK: - Public Methods
    func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}
