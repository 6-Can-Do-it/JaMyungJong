//
//  SettingView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/8/25.
//

import UIKit
import SnapKit

//피커뷰가 포함된 메인뷰
class SettingMainView: UIView {
    
    private var timer = Timer()
    //datePicker에서 선택된 값을 저장하기 위한 변수
    private var selectedDate: Date?
    private var timeRemaining: TimeInterval = 0
    
    let daySetView = DaySetView()
    let missionSetView = MissonSetView()
    let soundSetView = SoundSetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureUI()
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
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.backgroundColor = .white
        picker.locale = Locale(identifier: "ko-KR")
        picker.addTarget(self, action: #selector(datePickerVlaue), for: .valueChanged)
        
        return picker
    }()
    
    @objc func datePickerVlaue(sender: UIDatePicker) {
        selectedDate = sender.date
        
        let calendar = Calendar.current
        let now = Date()
        
        //시스템 (현재) 시간
        let today = calendar.dateComponents([.hour, .minute], from: now
        )
        //선택한 시간
        let selected = calendar.dateComponents([.hour, .minute], from: selectedDate!)
        
        let selectedMinutes = (selected.hour! * 60) + selected.minute!
        let currentMinutes = (today.hour! * 60) + today.minute!
        var timeDiff = selectedMinutes - currentMinutes
        
        if timeDiff < 0 {
            timeDiff += 24 * 60
        }
        
        let hoursDiff = timeDiff / 60
        let minutesDiff = timeDiff % 60
        
        timeDiffLabel.text = String("\(hoursDiff)시간 \(minutesDiff)분 후에 알림이 울릴 예정이에요")
    }
    
    private func setTimer(with countDown: Double) {
        timer.invalidate()
    }
    deinit {
        timer.invalidate()
    }

    
    private lazy var stackViewForUIView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daySetView,missionSetView,soundSetView])
        stackView.spacing = 10
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private func configureUI() {
        //기본뷰와,datePicker 레이아웃 설정
        [stackViewForUIView, datePicker, timeDiffLabel].forEach { self.addSubview($0)}
        
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
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        //설정을 담당하는 뷰들의 레이아웃
        [daySetView,missionSetView,soundSetView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(150)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


@available(iOS 17.0, *)
#Preview {
    SetAlarmViewController()
}
