import UIKit

protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ sound: String)
}

final class SoundSelectionViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: SoundSelectionDelegate?
    var selectedSound: String?
    private let sounds = ["Radar", "Beacon", "Chimes", "Circuit", "Reflection", "Apex", "Presto", "Waves", "Signal", "Radar", "Beacon", "Chimes", "Circuit", "Reflection", "Apex", "Presto", "Waves", "Signal", "Radar", "Beacon", "Chimes", "Circuit", "Reflection", "Apex", "Presto", "Waves", "Signal"]

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SoundCell")
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
        title = "타이머 종료시"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "설정",
            style: .done,
            target: self,
            action: #selector(closeButtonTapped)
        )

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .darkGray
        cell.selectionStyle = .default

        // 체크박스를 위한 공간 유지
        if sound == selectedSound {
            cell.imageView?.image = UIImage(systemName: "checkmark") // 체크박스 이미지를 설정
            cell.imageView?.tintColor = .white // 체크박스 색상 설정
        } else {
            // 빈 공간을 유지하기 위해 투명한 이미지 설정
            cell.imageView?.image = UIImage()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        selectedSound = sound
        delegate?.didSelectSound(sound)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
