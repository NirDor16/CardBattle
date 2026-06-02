import Foundation

class PlayerDataManager {
    static let shared = PlayerDataManager()
    private init() {}

    private let nameKey = "playerName"

    var playerName: String? {
        get { UserDefaults.standard.string(forKey: nameKey) }
        set { UserDefaults.standard.set(newValue, forKey: nameKey) }
    }
}
