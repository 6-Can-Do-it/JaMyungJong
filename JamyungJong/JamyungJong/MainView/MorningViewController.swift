//
//  MorningViewController.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/8/25.
//

import UIKit
import SnapKit

class MornigViewController: UIViewController {
    
    let textButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘도 활기차게!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        return button
    }()
    
    let temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-1°C"
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .medium)
        return label
    }()
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "sun.max.fill")
        return imageView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "seoul"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("정확한 위치: 꺼짐", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray.withAlphaComponent(0.3)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private var isFortuneCracked = false
    
    let fortuneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "fortune_cookie_normal")
        return imageView
    }()
    
    let fortuneMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        label.text = "행운의 메시지가 도착했습니다!"
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
//        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemTeal
        
        temperatureStackView.addArrangedSubview(weatherIconImageView)
        temperatureStackView.addArrangedSubview(temperatureLabel)
        
        [textButton, temperatureStackView, locationLabel, locationButton, fortuneImageView, fortuneMessageLabel].forEach {
            view.addSubview($0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fortuneImageTapped))
        fortuneImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        textButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        temperatureStackView.snp.makeConstraints{ make in
            make.top.equalTo(textButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        weatherIconImageView.snp.makeConstraints{ make in
            make.width.height.equalTo(40)
        }
        
        locationLabel.snp.makeConstraints{ make in
            make.top.equalTo(temperatureStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        
        locationButton.snp.makeConstraints{ make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        fortuneImageView.snp.makeConstraints{ make in
            make.top.equalTo(locationButton.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        fortuneMessageLabel.snp.makeConstraints{ make in
            make.top.equalTo(fortuneImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    

    @objc private func fortuneImageTapped() {
        if isFortuneCracked {
            // 이미 깨진 상태면 리셋
            resetFortuneCookie()
        } else {
            // 깨지지 않은 상태면 깨기
            UIView.animate(withDuration: 0.3, animations: {
                self.fortuneImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self.fortuneImageView.transform = .identity
                    // 깨진 이미지로 변경
                    self.fortuneImageView.image = UIImage(named: "fortune_cookie_cracked")
                    
                    // 메시지 표시 애니메이션
                    self.fortuneMessageLabel.alpha = 1
                    self.showFortuneMessage()
                }
            }
            
            isFortuneCracked = true
        }
    }
    
    private func resetFortuneCookie() {
        isFortuneCracked = false
        fortuneImageView.image = UIImage(named: "fortune_cookie_normal")
        fortuneMessageLabel.alpha = 0
    }
    
    private func showFortuneMessage() {
        let FortuneMessage = [
            "오늘은 특별한 행운이 찾아올 거예요!",
            "당신의 긍정적인 마음가짐이 좋은 결과를 가져올 거예요",
            "오늘 하루도 행복한 일만 가득할 거예요",
            "기대하지 않은 즐거운 만남이 있을 거예요",
            "작은 기쁨이 당신을 찾아올 거예요",
            "오늘 당신의 결정은 모두 옳은 방향일 거예요",
            "기다리던 소식을 곧 듣게 될 거예요",
            "새로운 시작을 위한 완벽한 날이에요",
            "당신의 꿈이 한 걸음 더 가까워질 거예요",
            "오늘 하는 일마다 순조롭게 풀릴 거예요",
            "소중한 사람과 특별한 추억을 만들 수 있는 날이에요",
            "당신의 노력이 곧 빛을 발할 거예요",
            "예상치 못한 행운의 선물이 기다리고 있어요",
            "오늘은 당신이 주인공인 날이에요",
            "새로운 기회가 문을 두드릴 거예요",
            "당신의 재능이 빛나는 순간이 다가오고 있어요",
            "좋은 에너지가 당신을 감싸고 있어요",
            "지금 가는 길이 옳은 길이에요",
            "작은 친절이 큰 행복으로 돌아올 거예요",
            "당신을 향한 따뜻한 마음이 전해질 거예요",
            "오늘은 새로운 도전을 시작하기 좋은 날이에요",
            "특별한 인연과의 만남이 기다리고 있어요",
            "당신의 미소가 주변을 밝게 비출 거예요",
            "원하던 일이 순조롭게 진행될 거예요",
            "감사한 마음이 행복을 가져다줄 거예요",
            "당신의 열정이 주변 사람들에게 영감을 줄 거예요",
            "오늘 하루는 특별한 추억으로 남을 거예요",
            "작은 변화가 큰 기쁨이 될 거예요",
            "당신의 직감을 믿으세요, 옳은 선택일 거예요",
            "평화로운 하루가 당신을 기다리고 있어요",
            "소소한 일상에서 특별한 행복을 발견하게 될 거예요",
            "당신의 따뜻한 마음이 누군가에게 힘이 될 거예요",
            "기다리던 기회가 찾아올 거예요",
            "당신의 창의력이 빛을 발할 거예요",
            "좋은 사람들과의 만남이 이어질 거예요",
            "긍정적인 변화의 바람이 불어올 거예요",
            "당신의 꿈을 향한 발걸음이 더욱 가벼워질 거예요",
            "오늘 하루는 행운으로 가득할 거예요",
            "새로운 도전이 값진 경험이 될 거예요",
            "당신의 하루가 반짝이는 순간으로 가득할 거예요"
        ]
        
        let randomMessage = FortuneMessage.randomElement() ?? FortuneMessage[0]
        
        UIView.transition(with: fortuneMessageLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.fortuneMessageLabel.text = randomMessage
        })
    }
    
    private func updateWeatherIcon(with iconCode: String) {
        // OpenWeather 아이콘 코드를 시스템 아이콘으로 변환
        let systemIcon: String
        switch iconCode {
        case "01d": systemIcon = "sun.max.fill"
        case "01n": systemIcon = "moon.fill"
        case "02d": systemIcon = "cloud.sun.fill"
        case "02n": systemIcon = "cloud.moon.fill"
        case "03d", "03n": systemIcon = "cloud.fill"
        case "04d", "04n": systemIcon = "cloud.heavyrain.fill"
        case "09d", "09n": systemIcon = "cloud.rain.fill"
        case "10d": systemIcon = "cloud.sun.rain.fill"
        case "10n": systemIcon = "cloud.moon.rain.fill"
        case "11d", "11n": systemIcon = "cloud.bolt.fill"
        case "13d", "13n": systemIcon = "snow"
        case "50d", "50n": systemIcon = "cloud.fog.fill"
        default: systemIcon = "sun.max.fill"
        }
        weatherIconImageView.image = UIImage(systemName: systemIcon)
    }
}
