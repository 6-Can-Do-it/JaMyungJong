//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import UIKit

class SoundCell: UITableViewCell {
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    let soundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        backgroundColor = .darkGray
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(checkmarkImageView)
        addSubview(soundLabel)
        
        checkmarkImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24) // 고정 크기
        }
        
        soundLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with sound: String, isSelected: Bool) {
        soundLabel.text = sound
        checkmarkImageView.image = isSelected ? UIImage(systemName: "checkmark") : nil
    }
}
