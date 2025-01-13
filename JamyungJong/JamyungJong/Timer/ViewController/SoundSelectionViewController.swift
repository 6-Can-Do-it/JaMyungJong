//
//  Untitled.swift
//  JamyungJong
//
//  Created by 황석범 on 1/10/25.
//

import UIKit
import AVFoundation

protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ sound: String)
}

final class SoundSelectionViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: SoundSelectionDelegate?
    var selectedSound: String?
    private let sounds = SoundLibrary.sounds // SoundLibrary에서 사운드 리스트 가져오기

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SoundCell.self, forCellReuseIdentifier: "SoundCell")
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .black
        title = "타이머 종료 시"
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        let closeButton = UIBarButtonItem(
            title: "닫기",
            style: .done,
            target: self,
            action: #selector(closeButtonTapped)
        )
        closeButton.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        navigationItem.rightBarButtonItem = closeButton

        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SoundSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath) as? SoundCell else {
            return UITableViewCell()
        }
        let sound = sounds[indexPath.row]
        cell.configure(with: sound.name, isSelected: sound.name == selectedSound)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        selectedSound = sound.name
        delegate?.didSelectSound(sound.name)

        // SoundManager를 통해 소리 재생
        SoundManager.shared.playSound(fromAssetsNamed: sound.fileName)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
