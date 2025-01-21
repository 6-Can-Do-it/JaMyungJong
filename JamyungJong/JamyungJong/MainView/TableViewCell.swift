//
//  TableViewCell.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/10/25.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    private let dtTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 날짜 변환을 위한 DateFormatter 추가
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 입력 형식
        return formatter
    }()
    
    private let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd EEE HH:mm" // 출력 형식 (Mon, Tue, etc.)
        formatter.locale = Locale(identifier: "ko_KR") // 영어로 표시
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .black
        [
            dtTextLabel,
            tempLabel
        ].forEach { contentView.addSubview($0)}
        
        dtTextLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        tempLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        // 문자열을 Date 객체로 변환
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        // Date 객체를 원하는 형식의 문자열로 변환
        return outputFormatter.string(from: date)
    }
    
    public func configureCell(forecastWeather: ForecastWeather) {
        // 날짜 포맷 변환 적용
        dtTextLabel.text = formatDate(forecastWeather.dtTxt)
        // 온도는 소수점 제거
        tempLabel.text = "\(Int(round(forecastWeather.main.temp)))°C"
    }
}
