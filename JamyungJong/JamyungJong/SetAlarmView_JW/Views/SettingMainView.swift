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
    
    let daySetView = DaySetView()
    let missionSetView = MissonSetView()
    let soundSetView = SoundSetView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureUI()
    }
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .time
        picker.backgroundColor = .white
        picker.locale = NSLocale.autoupdatingCurrent
        
        return picker
    }()
    
    private lazy var stackViewForUIView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daySetView,missionSetView,soundSetView])
        stackView.spacing = 10
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private func configureUI() {
        //기본뷰와,datePicker 레이아웃 설정
        [stackViewForUIView, datePicker].forEach { self.addSubview($0)}
        
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

