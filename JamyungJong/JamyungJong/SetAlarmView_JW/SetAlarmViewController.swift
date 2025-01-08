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
    let settingView = SettingMainView()
    
    override func loadView() {
        view = settingView
    }
    override func viewDidLoad() {
    }
}


@available(iOS 17.0, *)
#Preview {
    SetAlarmViewController()
}
