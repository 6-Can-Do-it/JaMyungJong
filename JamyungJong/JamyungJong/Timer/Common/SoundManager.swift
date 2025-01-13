//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    // Assets에서 소리 파일 재생
    func playSound(fromAssetsNamed assetName: String) {
        guard let asset = NSDataAsset(name: assetName) else {
            print("Assets에서 파일을 찾을 수 없습니다: \(assetName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: asset.data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("오디오 재생 오류: \(error.localizedDescription)")
        }
    }
}
