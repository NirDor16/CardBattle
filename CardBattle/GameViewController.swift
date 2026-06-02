import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var pcNameLabel: UILabel!
    @IBOutlet weak var pcScoreLabel: UILabel!
    @IBOutlet weak var playerCardImageView: UIImageView!
    @IBOutlet weak var timerIconImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pcCardImageView: UIImageView!

    var playerName: String = "Player"
    var playerSide: String = "East Side"

    private let engine = GameEngine()

    private var myNameLabel: UILabel!
    private var myScoreLabel: UILabel!
    private var myCardView: UIImageView!
    private var opponentScoreLabel: UILabel!
    private var opponentCardView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assignSides()
        setupUI()
        setupEngine()
        engine.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func assignSides() {
        if playerSide == "East Side" {
            myNameLabel      = pcNameLabel
            myScoreLabel     = pcScoreLabel
            myCardView       = pcCardImageView
            opponentScoreLabel = playerScoreLabel
            opponentCardView   = playerCardImageView
            playerNameLabel.text = "PC"
        } else {
            myNameLabel      = playerNameLabel
            myScoreLabel     = playerScoreLabel
            myCardView       = playerCardImageView
            opponentScoreLabel = pcScoreLabel
            opponentCardView   = pcCardImageView
            pcNameLabel.text = "PC"
        }
    }

    private func setupUI() {
        myNameLabel.text    = playerName
        myScoreLabel.text   = "0"
        opponentScoreLabel.text = "0"
        timerLabel.text = "5"
        timerIconImageView.image = UIImage(systemName: "stopwatch")
        timerIconImageView.tintColor = .label

        for iv in [myCardView, opponentCardView] {
            iv?.layer.cornerRadius = 12
            iv?.clipsToBounds      = true
            iv?.contentMode        = .scaleAspectFit
            iv?.image              = UIImage(named: "card_back")
        }
    }

    private func setupEngine() {
        engine.onTick = { [weak self] seconds in
            DispatchQueue.main.async { self?.timerLabel.text = "\(seconds)" }
        }

        engine.onRevealCards = { [weak self] playerCard, pcCard in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.timerLabel.text = ""
                UIView.transition(with: self.myCardView,
                                  duration: 0.4, options: .transitionFlipFromLeft) {
                    self.myCardView.image = UIImage(named: playerCard.imageName)
                }
                UIView.transition(with: self.opponentCardView,
                                  duration: 0.4, options: .transitionFlipFromRight) {
                    self.opponentCardView.image = UIImage(named: pcCard.imageName)
                }
            }
        }

        engine.onHideCards = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIView.transition(with: self.myCardView,
                                  duration: 0.4, options: .transitionFlipFromRight) {
                    self.myCardView.image = UIImage(named: "card_back")
                }
                UIView.transition(with: self.opponentCardView,
                                  duration: 0.4, options: .transitionFlipFromLeft) {
                    self.opponentCardView.image = UIImage(named: "card_back")
                }
            }
        }

        engine.onRoundResult = { [weak self] _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.myScoreLabel.text       = "\(self.engine.playerScore)"
                self.opponentScoreLabel.text = "\(self.engine.pcScore)"
                self.timerLabel.text         = "5"
            }
        }

        engine.onGameOver = { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: "showSummary", sender: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSummary",
           let summaryVC = segue.destination as? SummaryViewController {
            let ps = engine.playerScore
            let cs = engine.pcScore
            if ps > cs {
                summaryVC.winnerName  = playerName
                summaryVC.winnerScore = ps
            } else {
                summaryVC.winnerName  = "PC"
                summaryVC.winnerScore = cs
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        engine.stop()
    }
}
