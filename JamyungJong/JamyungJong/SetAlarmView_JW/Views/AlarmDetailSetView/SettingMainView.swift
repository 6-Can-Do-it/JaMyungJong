//
//  SettingView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/8/25.
//

import UIKit
import SnapKit

//버튼을 눌렀을때 데이터 전달을 위한 프로토콜
protocol SettingMainViewDelegate: AnyObject {
    func didTapSaveButton(alarm: AlarmData)
    func didTapCancelButton()
}

//피커뷰가 포함된 메인뷰
class SettingMainView: UIView {
    
    private var timer = Timer()
    //datePicker에서 선택된 값을 저장하기 위한 변수
    private var selectedDate: Date = Date()
    private var timeRemaining: TimeInterval = 0
    weak var delegate: SettingMainViewDelegate?
    
    let daySetView = DaySetView()
    let soundSetView = SoundSetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureUI()
        datepickerUISet()
    }
    private let timeDiffLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()

        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.backgroundColor = .black
        picker.locale = Locale(identifier: "ko-KR")
        picker.addTarget(self, action: #selector(datePickerVlaue), for: .valueChanged)
        
        return picker
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.backgroundColor = SubColor.darkTurquoisePoint
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private func datepickerUISet() {
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    @objc private func saveButtonTapped() {
        print("SettingMainView - Save button tapped")
        let newAlarm = AlarmData(
            time: selectedDate,
            repeatDays: daySetView.getSelectedDays(),
            isEnabled: true
        )
        delegate?.didTapSaveButton(alarm: newAlarm)
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.didTapCancelButton()
    }
    
    @objc func datePickerVlaue(sender: UIDatePicker) {
        selectedDate = sender.date
    }
    
    func updateAlarmTime() {
//        guard let selectedDate = selectedDate else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        let selectedComponents = calendar.dateComponents([.hour, .minute], from: selectedDate)
        let currentComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: now)
        
        let selectedDays = daySetView.getSelectedDays()
        
        var minimumDaysDiff = Int.max
        //현재 요일 1- 일요일...
        let currentWeekday = currentComponents.weekday!
        
        for (index, isSelected) in selectedDays.enumerated() {
            guard isSelected else { continue }
            
            //요일 변환
            let targetWeekday = index == 0 ? 1 : index + 1
            
            var daysDiff = targetWeekday - currentWeekday
            if daysDiff <= 0 {
                daysDiff += 7
            }
            //같은 날이고 현재시간이 선택된 시간보다 이후라면 다음주로
            if daysDiff == 0 {
                let currentTime = calendar.dateComponents([.hour, .minute], from: now)
                if currentTime.hour! > selectedComponents.hour! || (currentTime.hour! == selectedComponents.hour! && currentTime.minute! >= selectedComponents.minute!) {
                    daysDiff = 7
                }
            }
            if daysDiff < minimumDaysDiff {
                minimumDaysDiff = daysDiff
            }
        }
        if minimumDaysDiff != Int.max {
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.day! += minimumDaysDiff
            components.hour = selectedComponents.hour
            components.minute = selectedComponents.minute
            
            if let date = calendar.date(from: components) {
                let timeDiff = date.timeIntervalSince(now)
                let hours = Int(timeDiff) / 3600
                let minutes = (Int(timeDiff) % 3600) / 60
                
                timeDiffLabel.text = "\(hours)시간 \(minutes)분 후에 알람이 울릴 예정이에요"
            }
        }
        
    }
    
    private func setTimer(with countDown: Double) {
        timer.invalidate()
    }
    deinit {
        timer.invalidate()
    }
    
    private lazy var stackViewForUIView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daySetView,soundSetView])
        stackView.spacing = 10
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var stackViewForButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private func configureUI() {
        //기본뷰와,datePicker 레이아웃 설정
        [stackViewForUIView, datePicker, timeDiffLabel, stackViewForButton].forEach { self.addSubview($0)}
        
        timeDiffLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        stackViewForUIView.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        stackViewForButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(stackViewForUIView.snp.bottom).offset(50)
            $0.height.equalTo(60)
        }
        
        
        //설정을 담당하는 뷰들의 레이아웃
        [daySetView,soundSetView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(150)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: AlarmListViewController())
}
