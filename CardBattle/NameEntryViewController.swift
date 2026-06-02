import UIKit

class NameEntryViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.isEnabled = false
        styleButton(confirmButton)
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @objc private func textChanged() {
        confirmButton.isEnabled = !(nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
    }

    @IBAction func confirmTapped(_ sender: UIButton) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespaces), !name.isEmpty else { return }
        PlayerDataManager.shared.playerName = name
        dismiss(animated: true)
    }

    private func styleButton(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 94/255, green: 122/255, blue: 165/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}
