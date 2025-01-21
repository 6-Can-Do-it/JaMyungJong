//
//  MorningViewController.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/8/25.
//

import UIKit
import SnapKit
import CoreLocation

class MorningViewController: UIViewController {
    
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
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
   
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // 그라데이션 색상 설정
        gradientLayer.colors = [
            UIColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1.0).cgColor ,
            UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1.0).cgColor
        ]
        
        // 그라데이션 방향 설정
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        // 그라데이션 레이어를 view의 맨 뒤에 삽입
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupLocationManager()
        setupGradientBackground()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        DispatchQueue.main.async {
            self.setupLocationManager()
        }
    }
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 현재 권한 상태 확인
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // 권한이 결정되지 않은 경우에만 요청
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        case .authorizedWhenInUse, .authorizedAlways:
            // 이미 권한이 있는 경우 위치 업데이트 시작
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // 권한이 거부된 경우 기본 위치(서울) 사용
            let seoulLat = 37.5665
            let seoulLon = 126.9780
            fetchWeatherData(lat: seoulLat, lon: seoulLon)
        @unknown default:
            break
        }
    }
    
    
    private func fetchWeatherData(lat: Double, lon: Double) {
        let urlString = "\(Configuration.baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(Configuration.apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.updateWeatherUI(with: weatherData)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
    
    private func updateWeatherUI(with weather: WeatherModel) {
        // 온도 업데이트
        let temperature = Int(round(weather.main.temp))
        temperatureLabel.text = "\(temperature)°C"
        
        // 날씨 아이콘 업데이트
        if let weatherCondition = weather.weather.first {
            updateWeatherIcon(with: weatherCondition.icon)
            
            // 날씨 상태 업데이트
            locationLabel.text = weatherCondition.main.capitalized
        }
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
        
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func locationButtonTapped() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                // 설정으로 이동하기
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
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
                } completion: { _ in
                    // 2초 후에 WeatherViewController로 전환
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.navigateToWeatherViewController()
                    }
                }
            }
            
            isFortuneCracked = true
        }
    }
    
    // WeatherViewController로 전환하는 메서드 추가
    //    private func navigateToWeatherViewController() {
    //        let weatherVC = WeatherViewController()
    //        weatherVC.modalPresentationStyle = .fullScreen
    //        weatherVC.modalTransitionStyle = .crossDissolve
    //        present(weatherVC, animated: true)
    //    }
    private func navigateToWeatherViewController() {
        let weatherVC = WeatherViewController()
        navigationController?.pushViewController(weatherVC, animated: true)
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
            "당신의 하루가 반짝이는 순간으로 가득할 거예요",
            "오늘은 우산을 챙기는 게 좋을지도 몰라요...",
            "조금 힘든 하루가 될 수 있어요, 하지만 이겨낼 수 있어요",
            "예상치 못한 지출이 생길 수 있으니 주의하세요",
            "오늘은 중요한 결정을 미루는 게 좋을 것 같아요",
            "평소보다 피곤함을 느낄 수 있는 하루네요",
            "마음에 들지 않는 소식을 들을 수 있어요",
            "가까운 사람과 작은 다툼이 있을 수 있어요",
            "계획했던 일이 예상과 다르게 진행될 수 있어요",
            "건강관리에 특히 신경 써야 할 것 같아요",
            "서두르다 실수할 수 있으니 여유를 가지세요",
            "오늘은 교통이 혼잡할 수 있으니 일찍 출발하세요",
            "집중력이 떨어질 수 있는 하루예요, 꼼꼼히 확인하세요",
            "평소보다 스트레스를 많이 받을 수 있어요",
            "기술적인 문제가 발생할 수 있으니 백업을 챙기세요",
            "예기치 못한 방해요소가 생길 수 있어요",
            "오늘은 욕심을 부리지 않는 게 좋을 것 같아요",
            "평소보다 체력이 떨어질 수 있으니 무리하지 마세요",
            "작은 실수가 큰 문제로 이어질 수 있어요, 신중하세요",
            "기대했던 일이 지연될 수 있어요, 인내심을 가지세요",
            "주변 사람들의 기분이 좋지 않을 수 있으니 조심하세요"
        ]
        
        let randomMessage = FortuneMessage.randomElement() ?? FortuneMessage[0]
        
        UIView.transition(with: fortuneMessageLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.fortuneMessageLabel.text = randomMessage
        })
    }
    
    // 기존의 updateWeatherIcon 함수를 수정된 버전으로 교체
    private func updateWeatherIcon(with iconCode: String) {
        let iconMapping: [String: String] = [
            "01d": "sun.max.fill",
            "01n": "moon.fill",
            "02d": "cloud.sun.fill",
            "02n": "cloud.moon.fill",
            "03d": "cloud.fill",
            "03n": "cloud.fill",
            "04d": "smoke.fill",
            "04n": "smoke.fill",
            "09d": "cloud.rain.fill",
            "09n": "cloud.rain.fill",
            "10d": "cloud.sun.rain.fill",
            "10n": "cloud.moon.rain.fill",
            "11d": "cloud.bolt.fill",
            "11n": "cloud.bolt.fill",
            "13d": "snow",
            "13n": "snow",
            "50d": "cloud.fog.fill",
            "50n": "cloud.fog.fill"
        ]
        
        let systemImageName = iconMapping[iconCode] ?? "sun.max.fill"
        weatherIconImageView.image = UIImage(systemName: systemImageName)
    }
}

// MARK: - CLLocationManagerDelegate
extension MorningViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationButton.setTitle("정확한 위치: 켜짐", for: .normal)
            
        case .denied, .restricted:
            locationButton.setTitle("정확한 위치: 꺼짐", for: .normal)
            // 위치 권한이 거부된 경우 기본 위치(서울)의 날씨 정보를 가져올 수 있습니다
            let seoulLat = 37.5665
            let seoulLon = 126.9780
            fetchWeatherData(lat: seoulLat, lon: seoulLon)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationButton.setTitle("정확한 위치: 꺼짐", for: .normal)
            
        @unknown default:
            locationButton.setTitle("정확한 위치: 꺼짐", for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 위치 업데이트가 성공하면 위치 업데이트를 중지
        locationManager.stopUpdatingLocation()
        
        // 현재 위치 저장
        currentLocation = location
        
        // 날씨 데이터 가져오기
        fetchWeatherData(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        
        // 위치 정보로 도시 이름 가져오기
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let cityName = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    self?.locationLabel.text = cityName
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        locationButton.setTitle("위치 오류", for: .normal)
        
        // 위치 서비스 오류 시 서울의 날씨 정보를 가져옵니다
        let seoulLat = 37.5665
        let seoulLon = 126.9780
        fetchWeatherData(lat: seoulLat, lon: seoulLon)
    }
}
