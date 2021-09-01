//
//  ConcentrationViewController.swift
//  Concentration
//
//  Created by allan galdino on 11/08/21.
//

import UIKit

class ConcentrationViewController: UIViewController {

    // MARK: - Properties

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int { (cardButtons.count + 1) / 2 }

    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }

    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.black
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)",
                                                  attributes: attributes)

        flipCountLabel.attributedText = attributedString
    }

    // MARK: - Outlets

    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }

    @IBOutlet private var cardButtons: [UIButton]!

    // MARK: - Actions

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    // MARK: - Contents

    private func updateViewFromModel() {
        guard cardButtons != nil else { return }

        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .lightGray
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .none : .systemBlue
            }
        }
    }

    // MARK: - Emoji

    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }

    private var emojiChoices = "👻🎃🦇😱🙀🍭🍬🍎"

    private var emoji = [Int: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex,
                                                       offsetBy: emojiChoices.count.arc4random)
            emoji[card.identifier] = String(emojiChoices.remove(at: randomStringIndex))
        }

        return emoji[card.identifier] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
