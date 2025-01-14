//
//  TimerView.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import QuartzCore
import UIKit

final class TimerCell: UITableViewCell {
    
    // MARK: - Properties
    var isTimerRunning = false
    var toggleTimer: (() -> Void)? // 타이머 상태를 제어하는 클로저
    
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
        view.backgroundColor = SubColor.dogerBlue
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    private let circularProgressLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 6
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = MainColor.aliceColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        return shapeLayer
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
        setupCircularProgressLayer()
        configureButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        backgroundColor = .clear
        
        [mainLabel, subLabel, progressContainerView, separatorView].forEach { contentView.addSubview($0) }
        progressContainerView.addSubview(playButton)
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
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
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    private func setupCircularProgressLayer() {
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: 30, y: 30),
            radius: 28,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        circularProgressLayer.path = circularPath.cgPath
        progressContainerView.layer.addSublayer(circularProgressLayer)
    }
    
    // MARK: - Configuration
    func configure(hours: Int, minutes: Int, seconds: Int, progress: Float) {
        mainLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        subLabel.text = "\(hours)시간 \(minutes)분 \(seconds)초"
        updateProgress(progress)
    }
    
    // MARK: - Button Action
    private func configureButtonAction() {
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc private func playButtonTapped() {
        isTimerRunning.toggle()
    
        let imageName = isTimerRunning ? "pause.fill" : "play.fill"
        playButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        toggleTimer?()
    }
    
    // MARK: - Public Methods
    func updateProgress(_ progress: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circularProgressLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
}

