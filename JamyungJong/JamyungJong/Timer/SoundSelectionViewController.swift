import UIKit

protocol SoundSelectionDelegate: AnyObject {
    func didSelectSound(_ sound: String)
}

final class SoundSelectionViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: SoundSelectionDelegate?
    var selectedSound: String?
    private let sounds = ["Radar", "Beacon", "Chimes", "Circuit", "Reflection", "Apex", "Presto", "Waves", "Signal"]

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
        view.backgroundColor = .darkGray
        title = "타이머 종료시"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "설정",
            style: .done,
            target: self,
            action: #selector(closeButtonTapped)
        )

        view.addSubview(tableView)
        tableView.backgroundColor = .clear
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
        cell.backgroundColor = . lightGray
        cell.accessoryType = sound == selectedSound ? .checkmark : .none
        cell.selectionStyle = .default
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
