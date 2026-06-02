import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var winnerName: String = "PC"
    var winnerScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        winnerLabel.text = "Winner: \(winnerName)"
        scoreLabel.text = "score: \(winnerScore)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func backToMenuTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
