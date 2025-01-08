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
    
    //날짜선택 레이블
    private let dateSelectViewLabel: UILabel = {
        let label = UILabel()
        label.text = "매일"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
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
    
    private lazy var stackViewForDayButton: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dayButton)
        
        stackView.axis = .horizontal
        stackView.spacing = 25
        
        return stackView
    }()
    
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
        //체크박스
        checkBox.snp.makeConstraints {
            $0.centerY.equalTo(dateSelectViewLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(50)
            
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
