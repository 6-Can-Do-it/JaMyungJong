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
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
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
    
    let fortuneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20
//        imageView.image = UIImage(named: "forune_cookie")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemTeal
        
        temperatureStackView.addArrangedSubview(weatherIconImageView)
        temperatureStackView.addArrangedSubview(temperatureLabel)
        
        [textButton, temperatureStackView, locationLabel, locationButton, fortuneImageView].forEach {
            view.addSubview($0)
        }
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
    }

    private func setupActions() {
        textButton.addTarget(self, action: #selector(textButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textButtonTapped() {
        print("날씨 앱으로 이동")
    }

}
