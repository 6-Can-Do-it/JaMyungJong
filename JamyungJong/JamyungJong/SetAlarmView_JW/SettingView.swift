//
//  SettingView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/8/25.
//

import UIKit
import SnapKit

class SettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureUI()
        labelSet()
        ButtonSet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    //날짜선택 레이블
    private let dateSelectViewLabel: UILabel = {
        let label = UILabel()
        label.text = "매일"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    //날짜선택 뷰
    private lazy var dateSelectView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(dateSelectViewLabel)
        view.addSubview(checkBox)
        view.addSubview(stackViewForDayButton)
        
        return view
    }()
    //날짜버튼
    private let dayButton: [UIButton] = {
        let day = ["일", "월", "화", "수", "목", "금", "토"]
        var buttonArray: [UIButton] = []
        
        for dayList in day {
            let button = UIButton()
            button.backgroundColor = SubColor.darkTurquoisePoint
            button.titleLabel?.font = .boldSystemFont(ofSize: 20)
            button.setTitle(dayList, for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.width / 2
            buttonArray.append(button)
        }
        
        return buttonArray
    }()
    
    //체크박스 버튼
    private let checkBox: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("체크박스", for: .normal)
        
        return button
    }()
    
    
    //미션 선택레이블
    private let misssionSelectViewLabel: UILabel = {
        let label = UILabel()
        label.text = "미션"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        
        
        return label
    }()

    private lazy var misssionSelectView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(misssionSelectViewLabel)
        
        return view
    }()
    
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
    private lazy var alarmDetailSetView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.addSubview(stackViewForAlarmDetailSetViewFirstLine)
        
        return view
    }()
    
    private lazy var stackViewForUIView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateSelectView,misssionSelectView,alarmDetailSetView])
        stackView.spacing = 10
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var stackViewForDayButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dayButton)
        
        stackView.axis = .horizontal
        stackView.spacing = 25
        
        return stackView
    }()
    
    private lazy var stackViewForAlarmDetailSetViewFirstLine: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slider, uiSwitch])
        stackView.axis = .horizontal
        stackView.spacing = 30
        
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
        [dateSelectView,misssionSelectView,alarmDetailSetView].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(150)
            }
        }
    }
    private func ButtonSet() {
        stackViewForDayButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        checkBox.snp.makeConstraints {
            $0.centerY.equalTo(dateSelectViewLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(50)

        }
        
    }
    private func labelSet() {
        dateSelectViewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        misssionSelectViewLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        stackViewForAlarmDetailSetViewFirstLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
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
