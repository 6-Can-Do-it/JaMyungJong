//
//  DaySetView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/9/25.
//

import UIKit
import SnapKit

//요일 선택을 담당하는 뷰
class DaySetView: UIView {
    
    //체크박스 상태 변수
    private var isChecked = false
    let days = ["일", "월", "화", "수", "목", "금", "토"]
    private var selectedDays: [Bool] =  Array(repeating: false, count: 7)
    
    //날짜선택 레이블
    private let dateSelectViewLabel: UILabel = {
        let label = UILabel()
        label.text = "반복안함"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    //날짜버튼
    private lazy var dayButton: [UIButton] = {
        var buttonArray: [UIButton] = []
        
        for (index,dayList) in days.enumerated() {
            let button = UIButton()
            button.backgroundColor = .gray
            button.titleLabel?.font = .boldSystemFont(ofSize: 24)
            button.setTitle(dayList, for: .normal)
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2.0
            button.clipsToBounds = true
            button.layer.cornerRadius = 45 / 2
            //버튼 태그 설정
            button.tag = index
            button.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
            buttonArray.append(button)
        }
        
        return buttonArray
    }()
    
    //체크박스 버튼
    private let checkBox: UIButton = {
        let button = UIButton()
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        button.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var stackViewForDayButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dayButton)
        
        stackView.axis = .horizontal
        stackView.spacing = 7
        
        return stackView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetUI()
        setLayout()
    }
    
    // UIView 기본 셋팅
    private func basicSetUI() {
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.addSubview(dateSelectViewLabel)
        self.addSubview(checkBox)
        self.addSubview(stackViewForDayButton)
    }
    
    @objc private func checkBoxTapped() {
        isChecked.toggle()
        
        UIView.animate(withDuration: 0.2) {
            if self.isChecked {
                self.checkBox.backgroundColor = SubColor.darkTurquoisePoint
                // 체크마크 추가
                let checkmark = UIImage(systemName: "checkmark")?
                    .withTintColor(.black, renderingMode: .alwaysOriginal)
                self.checkBox.setImage(checkmark, for: .normal)
                self.selectedDays = Array(repeating: true, count: 7)
                self.dayButton.forEach { button in
                    button.backgroundColor = SubColor.darkTurquoisePoint
                }
            } else {
                self.checkBox.backgroundColor = .clear
                self.checkBox.setImage(nil, for: .normal)
                self.selectedDays = Array(repeating: false, count: 7)
                self.dayButton.forEach { button in
                    button.backgroundColor = .gray
                }
            }
        }
        updateDateSelectViewLabel()
    }
    
    @objc
    private func dayButtonTapped(sender: UIButton) {
        let index = sender.tag
        selectedDays[index].toggle()
        
        if selectedDays[index] {
            sender.backgroundColor = SubColor.darkTurquoisePoint
        } else {
            sender.backgroundColor = .gray
        }
        updateDateSelectViewLabel()
    }
    
    //레이블 업데이트 로직
    private func updateDateSelectViewLabel() {
        let selectedCount = selectedDays.filter { $0 }.count
        
        if selectedCount == 0 {
            dateSelectViewLabel.text = "반복안함"
            return
        }
        
        if selectedCount == 7 {
            dateSelectViewLabel.text = "매일"
            return
        }
        
        let weekdaysSelected = selectedDays[1...5].allSatisfy { $0 } &&
        !selectedDays[0] && !selectedDays[6]
        if weekdaysSelected {
            dateSelectViewLabel.text = "주중"
            return
        }
        
        let weekendSelected = selectedDays[0] && selectedDays[6] &&
        selectedDays[1...5].allSatisfy { !$0 }
        if weekendSelected {
            dateSelectViewLabel.text = "주말"
            return
        }
        
        let selectedDayTexts = selectedDays.enumerated()
            .filter { $0.element }
            .map { days[$0.offset] }
        
        if selectedDayTexts.count == 1 {
            dateSelectViewLabel.text = "\(selectedDayTexts[0])요일만"
        } else {
            dateSelectViewLabel.text = selectedDayTexts.joined(separator: ", ")
        }
        
    }
    
    private func setLayout() {
        dateSelectViewLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        //날짜버튼
        stackViewForDayButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        dayButton.forEach { button in
            button.snp.makeConstraints {
                $0.width.height.equalTo(45)
            }
        }
        //체크박스
        checkBox.snp.makeConstraints {
            $0.centerY.equalTo(dateSelectViewLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(50)
            $0.width.height.equalTo(35)
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

