import Foundation

class GameEngine {
    let totalRounds = 10
    let countdownDuration = 5
    let revealDuration: TimeInterval = 3.0

    private(set) var round = 0
    private(set) var playerScore = 0
    private(set) var pcScore = 0

    private var timer: Timer?
    private var countdown = 0
    private var currentPlayerCard: Card?
    private var currentPCCard: Card?

    var onTick: ((Int) -> Void)?
    var onRevealCards: ((Card, Card) -> Void)?
    var onHideCards: (() -> Void)?
    var onRoundResult: ((Bool, Bool) -> Void)?
    var onGameOver: ((Int, Int) -> Void)?

    func start() {
        round = 0
        playerScore = 0
        pcScore = 0
        beginCountdown()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func beginCountdown() {
        currentPlayerCard = Card.random()
        currentPCCard     = Card.random()
        countdown = countdownDuration
        onTick?(countdown)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        countdown -= 1
        onTick?(countdown)

        guard countdown <= 0 else { return }
        timer?.invalidate()
        timer = nil
        revealCards()
    }

    private func revealCards() {
        guard let player = currentPlayerCard, let pc = currentPCCard else { return }
        onRevealCards?(player, pc)

        DispatchQueue.main.asyncAfter(deadline: .now() + revealDuration) { [weak self] in
            self?.hideAndEvaluate()
        }
    }

    private func hideAndEvaluate() {
        onHideCards?()
        guard let player = currentPlayerCard, let pc = currentPCCard else { return }

        var playerGot = false
        var pcGot = false
        if player.strength > pc.strength {
            playerScore += 1
            playerGot = true
        } else if pc.strength > player.strength {
            pcScore += 1
            pcGot = true
        }

        onRoundResult?(playerGot, pcGot)
        round += 1

        if round >= totalRounds {
            onGameOver?(playerScore, pcScore)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.beginCountdown()
            }
        }
    }
}
