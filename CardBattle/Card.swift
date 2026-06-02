import Foundation

struct Card {
    let imageName: String
    let strength: Int
    let displayName: String

    static let deck: [Card] = [
        Card(imageName: "card_001", strength: 14, displayName: "Ace of Spades"),
        Card(imageName: "card_002", strength: 14, displayName: "Ace of Clubs"),
        Card(imageName: "card_003", strength: 14, displayName: "Ace of Diamonds"),
        Card(imageName: "card_004", strength: 14, displayName: "Ace of Hearts"),
        Card(imageName: "card_005", strength: 2,  displayName: "Two of Spades"),
        Card(imageName: "card_006", strength: 2,  displayName: "Two of Clubs"),
        Card(imageName: "card_007", strength: 2,  displayName: "Two of Diamonds"),
        Card(imageName: "card_008", strength: 2,  displayName: "Two of Hearts"),
        Card(imageName: "card_009", strength: 3,  displayName: "Three of Spades"),
        Card(imageName: "card_010", strength: 3,  displayName: "Three of Clubs"),
        Card(imageName: "card_011", strength: 3,  displayName: "Three of Diamonds"),
        Card(imageName: "card_012", strength: 3,  displayName: "Three of Hearts"),
        Card(imageName: "card_013", strength: 4,  displayName: "Four of Spades"),
        Card(imageName: "card_014", strength: 4,  displayName: "Four of Clubs"),
        Card(imageName: "card_015", strength: 4,  displayName: "Four of Diamonds"),
        Card(imageName: "card_016", strength: 4,  displayName: "Four of Hearts"),
        Card(imageName: "card_017", strength: 5,  displayName: "Five of Spades"),
        Card(imageName: "card_018", strength: 5,  displayName: "Five of Clubs"),
        Card(imageName: "card_019", strength: 5,  displayName: "Five of Diamonds"),
        Card(imageName: "card_020", strength: 5,  displayName: "Five of Hearts"),
        Card(imageName: "card_021", strength: 6,  displayName: "Six of Spades"),
        Card(imageName: "card_022", strength: 6,  displayName: "Six of Clubs"),
        Card(imageName: "card_023", strength: 6,  displayName: "Six of Diamonds"),
        Card(imageName: "card_024", strength: 6,  displayName: "Six of Hearts"),
        Card(imageName: "card_025", strength: 7,  displayName: "Seven of Spades"),
        Card(imageName: "card_026", strength: 7,  displayName: "Seven of Clubs"),
        Card(imageName: "card_027", strength: 7,  displayName: "Seven of Diamonds"),
        Card(imageName: "card_028", strength: 7,  displayName: "Seven of Hearts"),
        Card(imageName: "card_029", strength: 8,  displayName: "Eight of Spades"),
        Card(imageName: "card_030", strength: 8,  displayName: "Eight of Clubs"),
        Card(imageName: "card_031", strength: 8,  displayName: "Eight of Diamonds"),
        Card(imageName: "card_032", strength: 8,  displayName: "Eight of Hearts"),
        Card(imageName: "card_033", strength: 9,  displayName: "Nine of Spades"),
        Card(imageName: "card_034", strength: 9,  displayName: "Nine of Clubs"),
        Card(imageName: "card_035", strength: 9,  displayName: "Nine of Diamonds"),
        Card(imageName: "card_036", strength: 9,  displayName: "Nine of Hearts"),
        Card(imageName: "card_037", strength: 10, displayName: "Ten of Spades"),
        Card(imageName: "card_038", strength: 10, displayName: "Ten of Clubs"),
        Card(imageName: "card_039", strength: 10, displayName: "Ten of Diamonds"),
        Card(imageName: "card_040", strength: 10, displayName: "Ten of Hearts"),
        Card(imageName: "card_041", strength: 11, displayName: "Jack of Spades"),
        Card(imageName: "card_042", strength: 11, displayName: "Jack of Clubs"),
        Card(imageName: "card_043", strength: 11, displayName: "Jack of Diamonds"),
        Card(imageName: "card_044", strength: 11, displayName: "Jack of Hearts"),
        Card(imageName: "card_045", strength: 12, displayName: "Queen of Spades"),
        Card(imageName: "card_046", strength: 12, displayName: "Queen of Clubs"),
        Card(imageName: "card_047", strength: 12, displayName: "Queen of Diamonds"),
        Card(imageName: "card_048", strength: 12, displayName: "Queen of Hearts"),
        Card(imageName: "card_049", strength: 13, displayName: "King of Spades"),
        Card(imageName: "card_050", strength: 13, displayName: "King of Clubs"),
        Card(imageName: "card_051", strength: 13, displayName: "King of Diamonds"),
        Card(imageName: "card_052", strength: 13, displayName: "King of Hearts"),
    ]

    static func random() -> Card {
        return deck.randomElement()!
    }
}
