//
//  SoundSetView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/9/25.
//

import UIKit
import SnapKit

class SoundSetView: UIView  {
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetUI()
        setLayout()
    }
    
    private func basicSetUI() {
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.addSubview(stackViewForAlarmDetailSetViewFirstLine)
        self.addSubview(soundLabel)
        self.addSubview(soundListButton)
    }
    
    //슬라이더
    private let slider: UISlider = {
        let slider = CustomSlider()
        //슬라이더 이미지 크기를 위한 config
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        //소리를 최대음량으로 높일시 심장마비 가능성이 있다 해서 하트 이미지로 채택
        let maxImage = UIImage(systemName: "heart.slash.circle.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let minImage = UIImage(systemName: "speaker.wave.1.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.maximumValueImage = maxImage
        slider.minimumValueImage = minImage
        slider.maximumTrackTintColor = .gray
        slider.minimumTrackTintColor = SubColor.darkTurquoisePoint
        
        return slider
    }()
    
    private let uiSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.onTintColor = SubColor.darkTurquoisePoint
        
        return uiSwitch
    }()
    
    private let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "사운드"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        
        return label
    }()
    
    private let soundListButton: UIButton = {
        let button = UIButton()
        button.setTitle("기본", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.layer.borderColor = SubColor.darkTurquoisePoint.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(soundListButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackViewForAlarmDetailSetViewFirstLine: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slider, uiSwitch])
        stackView.axis = .horizontal
        stackView.spacing = 30
        
        return stackView
    }()
    
    @objc
    private func soundListButtonTapped() {
//        let soundSetVC = SoundSetDetailViewController()
//        navigationController?.pushViewController(soundSetVC, animated: true)
    }
    
    private func setLayout() {
        stackViewForAlarmDetailSetViewFirstLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        soundLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
        soundListButton.snp.makeConstraints {
            $0.centerY.equalTo(soundLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(100)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//슬라이더 두께 조정을 위한 커스텀 클래스
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 10
        return newBounds
    }
}

@available(iOS 17.0, *)
#Preview {
    SetAlarmViewController()
}


