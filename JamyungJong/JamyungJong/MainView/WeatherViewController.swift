//
//  WeatherViewController.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/8/25.
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private var dataSource = [ForecastWeather]()
    
    private var urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "lat", value: "37.5" ),
        URLQueryItem(name: "lon", value: "126.9"),
        URLQueryItem(name: "appid", value: "d5c109a965afc245d1fe602487dac034"),
        URLQueryItem(name: "units", value: "metric")
    ]
    
    
    // MARK: - UI Components
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.text = "서울"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .bold)
        label.textColor = .white
        label.text = "20도"
        return label
    }()
    
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "11도"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "23도"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let tempStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLocationManager()
        setupLocationButton()
        checkLocationAuthorization()
        self.hidesBottomBarWhenPushed = false
        
    }
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted, .notDetermined:
            // 위치 권한이 없는 경우 기본 위치(서울)의 날씨 데이터를 보여줌
            fetchCurrentWeahterData()
            fetchForecastData()
        @unknown default:
            fetchCurrentWeahterData()
            fetchForecastData()
        }
    }
    
    
    private func  fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            let successRange = 200..<300
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodedData)
            } else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    // 서버에서 현재 날씨 데이터를 불러오는 메서드.
    private func fetchCurrentWeahterData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (result: WeatherModel?) in
            guard let self, let result else { return }
            
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(Int(result.main.temp))°C"
                self.tempMinLabel.text = "최소: \(Int(result.main.tempMin))°C"
                self.tempMaxLabel.text = "최대: \(Int(result.main.tempMax))°C"
            }
            guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(result.weather[0].icon)@2x.png") else {
                return
            }
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherIconImageView.image = image
                    }
                }
            }
        }
    }
    private func fetchForecastData() {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")
        urlComponents?.queryItems = self.urlQueryItems
        
        guard let url = urlComponents?.url else {
            print("잘못됫 URL")
            return
        }
        fetchData(url: url) { [weak self] (result: ForecastWeatherResult?) in
            guard let self, let result else { return }
            
            for forecastWeather in result.list {
                print("\(forecastWeather.main)\n\(forecastWeather.dtTxt)\n\n")
            }
            DispatchQueue.main.async {
                self.dataSource = result.list
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func configureUI() {
            view.backgroundColor = .black
            [
                cityLabel,
                temperatureLabel,
                tempStackView,
                weatherIconImageView,
                tableView,
                locationButton
            ].forEach { view.addSubview($0) }
            
            [
                tempMinLabel,
                tempMaxLabel
            ].forEach { tempStackView.addArrangedSubview($0) }
            
            cityLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(120)
            }
            
            temperatureLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(cityLabel.snp.bottom).offset(10)
            }
            
            tempStackView.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(temperatureLabel.snp.bottom).offset(10)
                
            }
            
            weatherIconImageView.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(160)
                make.top.equalTo(tempStackView.snp.bottom).offset(20)
            }
        
        tableView.snp.makeConstraints{ make in
            make.top.equalTo(weatherIconImageView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(50)
        }
        
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(44)
        }
        }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupLocationButton() {
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    @objc private func locationButtonTapped() {
        locationManager.requestLocation()
    }
    
    // URL 쿼리 아이템 업데이트 메서드
    private func updateURLQueryItems(latitude: Double, longitude: Double) {
        let newQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: "d5c109a965afc245d1fe602487dac034"),
            URLQueryItem(name: "units", value: "metric")
        ]
        self.urlQueryItems = newQueryItems
        
        // 새로운 위치로 날씨 데이터 업데이트
        fetchCurrentWeahterData()
        fetchForecastData()
    }
}
    





extension WeatherViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else { return UITableViewCell() }
        cell.configureCell(forecastWeather: dataSource[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
}


// Location Manager Delegate 확장
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        // 위치 정보로 날씨 데이터 업데이트
        updateURLQueryItems(latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude)
        
        // 위치 이름 가져오기
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  let placemark = placemarks?.first else { return }
            
            DispatchQueue.main.async {
                if let city = placemark.locality {
                    self.cityLabel.text = city
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 획득 실패: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // 알림창으로 설정 화면으로 이동하도록 안내
            let alert = UIAlertController(
                title: "위치 권한 필요",
                message: "날씨 정보를 얻기 위해 위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.",
                preferredStyle: .alert
            )
            
            let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            
            // 위치 권한이 없는 경우 기본 위치(서울)의 날씨 데이터를 보여줌
            fetchCurrentWeahterData()
            fetchForecastData()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            // 기본 위치의 날씨 데이터를 보여줌
            fetchCurrentWeahterData()
            fetchForecastData()
        }
    }
}
