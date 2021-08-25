//
//  Concentration.swift
//  Concentration
//
//  Created by allan galdino on 12/08/21.
//

import Foundation

struct Concentration {

    // MARK: - Properties

    private(set) var cards = [Card]()

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }

        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    // MARK: - Initializer

    init(numberOfPairsOfCards: Int) {
        assert(
            numberOfPairsOfCards > 0,
            "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        cards.shuffle()
    }

    // MARK: - Contents

    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index),
               "Concentration.chooseCard(at: \(index)): chosen index not in the cards")

        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard,
               matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }

                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

extension Collection {
    var oneAndOnly: Element? { count == 1 ? first : nil }
}
