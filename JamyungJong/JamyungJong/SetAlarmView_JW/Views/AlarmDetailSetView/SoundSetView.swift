//
//  SoundSetView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/9/25.
//

import UIKit
import SnapKit

class SoundSetView: UIView, SoundSelectionDelegate {
    private var selectedSound: String = "기본" {
        didSet {
            soundListButton.setTitle(selectedSound, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetUI()
        setLayout()
        setupInitialState()
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
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        let maxImage = UIImage(systemName: "heart.slash.circle.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let minImage = UIImage(systemName: "speaker.wave.1.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.maximumValueImage = maxImage
        slider.minimumValueImage = minImage
        slider.maximumTrackTintColor = .gray
        slider.minimumTrackTintColor = SubColor.darkTurquoisePoint
        
        // 슬라이더 초기값 및 범위 설정
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5 // 기본값
        
        // 연속적인 값 변경 허용
        slider.isContinuous = true
        
        // 값 변경 이벤트 추가
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        
        return slider
    }()
    
    // 음량 조절을 위한 메서드
    @objc private func sliderValueChanged(_ sender: UISlider) {
        if uiSwitch.isOn {
            // 볼륨값을 0.1 단위로 반올림하여 더 부드럽게 조절
            let roundedVolume = round(sender.value * 10) / 10
            SoundManager.shared.setVolume(roundedVolume)
        }
    }
    
    // 현재 설정된 음량 가져오기
    func getVolume() -> Float {
        return slider.value
    }
    
    // UISwitch 토글 시 사운드 켜고 끄기
    @objc private func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            slider.isEnabled = true
            // 스위치가 켜질 때 현재 선택된 사운드로 미리듣기
            SoundManager.shared.playSound(fromAssetsNamed: selectedSound)
        } else {
            slider.isEnabled = false
            SoundManager.shared.stopSound()
        }
    }
    
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
        guard let parentViewController = self.parentViewController else { return }
        let soundSelectionVC = SoundSelectionViewController()
        soundSelectionVC.delegate = self
        let navigationController = UINavigationController(rootViewController: soundSelectionVC)
        parentViewController.present(navigationController, animated: true, completion: nil)
    }
    
    func didSelectSound(_ sound: String) {
        selectedSound = sound
        //parentViewController?.dismiss(animated: true)
    }
    
    func getSelectedSound() -> String {
        return selectedSound
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
    
    private func setupInitialState() {
        // 초기 상태 설정
        uiSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        slider.isEnabled = uiSwitch.isOn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// UIView의 부모 뷰 컨트롤러를 찾기 위한 확장
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let nextResponder = parentResponder?.next {
            parentResponder = nextResponder
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
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
    UINavigationController(rootViewController: AlarmListViewController())
}
