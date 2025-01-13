//
//  SetAlarmViewController.swift
//  JamyungJong
//
//  Created by 진욱의 Macintosh on 1/8/25.
//

import Foundation
import UIKit
import SnapKit
class SetAlarmViewController: UIViewController {
    let settingMainView = SettingMainView()
    
    override func loadView() {
        view = settingMainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingMainView.delegate = self
        title = "알람 설정"
    }
}
extension SetAlarmViewController: SettingMainViewDelegate {
    func didTapSaveButton(alarm: AlarmData) {
        // 직접 static 배열에 추가
        AlarmListViewController.alarms.append(alarm)
        // 화면 전환
        navigationController?.popViewController(animated: true)
    }
    func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    SetAlarmViewController()
}
