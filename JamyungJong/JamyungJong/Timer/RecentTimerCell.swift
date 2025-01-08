//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/8/25.
//

import UIKit

final class RecentTimerCell: UITableViewCell {

    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .lightGray
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill") // 재생 버튼 아이콘
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        // UI 구성 추가
        let stackView = UIStackView(arrangedSubviews: [mainLabel, subLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        contentView.addSubview(playButton)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
