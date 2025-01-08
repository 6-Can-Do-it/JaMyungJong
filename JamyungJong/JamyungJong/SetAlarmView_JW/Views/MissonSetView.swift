//
//  MissonSetView.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/9/25.
//

import UIKit
import SnapKit

//미션 선택 뷰
class MissonSetView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetUI()
        setLayout()
    }
    
    private func basicSetUI() {
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.addSubview(missionSelectViewLabel)
        self.addSubview(stackViewForImageView)
    }
    //미션 선택레이블
    private let missionSelectViewLabel: UILabel = {
        let label = UILabel()
        label.text = "미션"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .left
        
        
        return label
    }()
    
    private let missionImageView: [UIImageView] = {
        var imageViewArray: [UIImageView] = []
        
        for _ in 1...3 {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.backgroundColor = .green
            imageViewArray.append(imageView)
        }
        print(imageViewArray.count)
        return imageViewArray
    }()
    
    private lazy var stackViewForImageView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: missionImageView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        return stackView
    }()
    
    private func setLayout() {
        missionSelectViewLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(30)
        }
        
        stackViewForImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(missionSelectViewLabel.snp.trailing).offset(20)
            $0.height.equalTo(85)
        }
        missionImageView.forEach { imageView in
                imageView.snp.makeConstraints {
                    $0.width.height.equalTo(85)
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
