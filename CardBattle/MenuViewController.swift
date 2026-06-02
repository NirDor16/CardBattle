import UIKit
import CoreLocation

class MenuViewController: UIViewController {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var leftEarthImageView: UIImageView!
    @IBOutlet weak var rightEarthImageView: UIImageView!
    @IBOutlet weak var westSideLabel: UILabel!
    @IBOutlet weak var eastSideLabel: UILabel!

    private var playerSide: String = "East Side" {
        didSet { updateGreeting() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton(startButton)
        startButton.isEnabled = false
        setupEarthConstraints()
        requestLocation()
    }

    private func setupEarthConstraints() {
        for iv in [leftEarthImageView!, rightEarthImageView!] {
            iv.constraints.forEach { $0.isActive = false }
            iv.translatesAutoresizingMaskIntoConstraints = false
        }
        view.constraints
            .filter { $0.firstItem === leftEarthImageView  || $0.secondItem === leftEarthImageView
                   || $0.firstItem === rightEarthImageView || $0.secondItem === rightEarthImageView }
            .forEach { $0.isActive = false }

        let d: CGFloat = 180
        NSLayoutConstraint.activate([
            leftEarthImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            leftEarthImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leftEarthImageView.widthAnchor.constraint(equalToConstant: d),
            leftEarthImageView.heightAnchor.constraint(equalToConstant: d),

            rightEarthImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            rightEarthImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rightEarthImageView.widthAnchor.constraint(equalToConstant: d),
            rightEarthImageView.heightAnchor.constraint(equalToConstant: d),
        ])

        for iv in [leftEarthImageView!, rightEarthImageView!] {
            iv.contentMode   = .scaleAspectFill
            iv.clipsToBounds = false
            iv.transform     = .identity
        }

        applyHalfCircleMask(to: leftEarthImageView,  leftHalf: true,  diameter: d)
        applyHalfCircleMask(to: rightEarthImageView, leftHalf: false, diameter: d)

        // right_earth has arc on the left → correct for the left screen edge
        leftEarthImageView.image  = UIImage(named: "right_earth")
        rightEarthImageView.image = UIImage(named: "left_earth")
    }

    // clockwise:false = left arc "(" (arc at x=0, flat cut at x=diameter/2)
    // clockwise:true  = right arc ")" (flat cut at x=diameter/2, arc at x=diameter)
    private func applyHalfCircleMask(to imageView: UIImageView, leftHalf: Bool, diameter: CGFloat) {
        let r = diameter / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: r, y: 0))
        path.addArc(withCenter: CGPoint(x: r, y: r), radius: r,
                    startAngle: -.pi / 2, endAngle: .pi / 2,
                    clockwise: !leftHalf)
        path.close()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        imageView.layer.mask = mask
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w      = view.bounds.width
        let labelY = leftEarthImageView.frame.maxY + 8
        westSideLabel.frame = CGRect(x: 8,       y: labelY, width: 110, height: 22)
        eastSideLabel.frame = CGRect(x: w - 118, y: labelY, width: 110, height: 22)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        updateGreeting()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PlayerDataManager.shared.playerName == nil {
            presentNameEntry()
        }
    }

    private func updateGreeting() {
        let name = PlayerDataManager.shared.playerName ?? ""
        greetingLabel.text = "Hi \(name)"
    }

    private func requestLocation() {
        LocationManager.shared.onLocationReceived = { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let lon = location.coordinate.longitude
                self.playerSide = lon > LocationManager.midLongitude ? "East Side" : "West Side"
                self.startButton.isEnabled = true
            }
        }
        LocationManager.shared.onLocationError = { [weak self] _ in
            DispatchQueue.main.async {
                self?.showLocationError()
            }
        }
        LocationManager.shared.requestLocation()
    }

    private func showLocationError() {
        let alert = UIAlertController(
            title: "Location Unavailable",
            message: "Could not determine your location. Please enable Location Services in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func presentNameEntry() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NameEntryVC") as! NameEntryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    @IBAction func insertNameTapped(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NameEntryVC") as! NameEntryViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @IBAction func startTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showGame", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame",
           let gameVC = segue.destination as? GameViewController {
            gameVC.playerName = PlayerDataManager.shared.playerName ?? "Player"
            gameVC.playerSide = playerSide
        }
    }

    private func styleButton(_ button: UIButton) {
        button.backgroundColor = UIColor(red: 94/255, green: 122/255, blue: 165/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .disabled)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
}
