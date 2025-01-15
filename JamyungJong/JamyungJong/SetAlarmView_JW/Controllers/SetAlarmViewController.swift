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
        
        if let navigationController = self.navigationController,
           let alarmListVC = navigationController.viewControllers.first as? AlarmListViewController {
            alarmListVC.addAlarm(alarm)
        }
        // 화면 전환
        navigationController?.popViewController(animated: true)
    }
    //알람 저장 메서드
//    private func saveAlarms(_ alarms: [AlarmData]) {
//        //JSON 인코딩
//        if let encoded = try? JSONEncoder().encode(alarms) {
//            UserDefaults.standard.set(encoded, forKey: "savedAlarms")
//        }
//    }
    //알람 로드 메서드
//    private func loadAlarms() -> [AlarmData] {
//        if let savedData = UserDefaults.standard.data(forKey: "savedAlarms"),
//           let decodedAlarms = try? JSONDecoder().decode([AlarmData].self, from: savedData) {
//            return decodedAlarms
//        }
//        return []
//    }
    
    func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    SetAlarmViewController()
//}
