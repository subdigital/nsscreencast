enum PokerHand {
  case highCard(CardValue)
  case pair(CardValue)
  case twoPair(CardValue, CardValue)
  case threeOfAKind(CardValue)
  case fourOfAKind(CardValue)
  case fullHouse(CardValue, CardValue)
  case straight(CardValue)
  case flush(Suit, CardValue)
  case straightFlush(Suit, CardValue)
  case royalFlush(Suit)
}

extension PokerHand : Equatable {
  static func ==(lhs: PokerHand, rhs: PokerHand) -> Bool {
    switch (lhs, rhs) {
    case let (.highCard(x1), .highCard(x2)):
      return x1 == x2

    case let (.pair(x1), .pair(x2)):
      return x1 == x2

    case let (.twoPair(x1, y1), .twoPair(x2, y2)):
      return x1 == x2 && y1 == y2

    case let (.threeOfAKind(x1), .threeOfAKind(x2)):
      return x1 == x2

    case let (.fourOfAKind(x1), .fourOfAKind(x2)):
      return x1 == x2

    case let (.fullHouse(x1, y1), .fullHouse(x2, y2)):
      return x1 == x2 && y1 == y2

    case let (.flush(s1, x1), .flush(s2, x2)):
      return s1 == s2 && x1 == x2

    case let (.straight(x1), .straight(x2)):
      return x1 == x2

    case let (.straightFlush(s1, x1), .straightFlush(s2, x2)):
      return s1 == s2 && x1 == x2

    case let (.royalFlush(s1), .royalFlush(s2)):
      return s1 == s2

    default: return false
    }
  }
}

struct Poker {
  let cards: [Card]

  init(cards: [Card]) {
    self.cards = cards
  }

  func judge() -> PokerHand? {
    let orderedHands: [ (Void) -> PokerHand? ] = [
      royalFlush,
      straightFlush,
      fourOfAKind,
      fullHouse,
      flush,
      straight,
      threeOfAKind,
      twoPair,
      pair,
      highCard,
    ]
    return orderedHands
      .lazy
      .flatMap { fn in return fn() }
      .first
  }

  private func highCard() -> PokerHand? {
    return cards.max().map { .highCard($0.value) }
  }

  private func pair() -> PokerHand? {
    return findRepeated(count: 2).map { .pair($0) }
  }

  private func twoPair() -> PokerHand? {
    guard let firstPair = findRepeated(count: 2),
          let secondPair = findRepeated(count:2, notMatching: firstPair) else {
            return nil
          }

    let (sortedFirst, sortedSecond) = firstPair > secondPair
      ? (firstPair, secondPair)
      : (secondPair, firstPair)

    return .twoPair(sortedFirst, sortedSecond)
  }

  private func fullHouse() -> PokerHand? {
    guard let triplet = findRepeated(count: 3),
          let pair = findRepeated(count:2) else {
            return nil
          }

    return .fullHouse(triplet, pair)
  }

  private func flush() -> PokerHand? {
    let sameSuit = cards.all { $0.suit == cards.first?.suit }
    if sameSuit, let highCard = cards.max() {
      return .flush(highCard.suit, highCard.value)
    }
    return nil
  }

  private func straight() -> PokerHand? {
      let sortedCards = cards.map { $0.value.value }.sorted()
      let pairs = zip(sortedCards, sortedCards.dropFirst())
      let allValuesConsecutive = pairs.all { $1 - $0 == 1 }
      if allValuesConsecutive, let maxCard = cards.max() {
        return .straight(maxCard.value)
      }
      return nil
  }

  private func straightFlush() -> PokerHand? {
    if straight() != nil && flush() != nil, let highCard = cards.max() {
      return .straightFlush(highCard.suit, highCard.value)
    }
    return nil
  }

  private func royalFlush() -> PokerHand? {
    if case let .straightFlush(suit, value)? = straightFlush(), value == 14 {
      return .royalFlush(suit)
    }
    return nil
  }

  private func threeOfAKind() -> PokerHand? {
    return findRepeated(count: 3).map { .threeOfAKind($0) }
  }

  private func fourOfAKind() -> PokerHand? {
    return findRepeated(count: 4).map { .fourOfAKind($0) }
  }

  private func findRepeated(count repetitionCount: Int, notMatching: CardValue? = nil) -> CardValue? {
    let counts = computeCounts()
    if let (cardValue, _) = counts.first(where: { (cardValue, count) in
        return count == repetitionCount && cardValue != notMatching
      }) {
      return cardValue
    }
    return nil
  }

  func computeCounts() -> [CardValue: Int] {
    var counts = [CardValue: Int]()
    for card in cards {
      counts[card.value] = (counts[card.value] ?? 0) + 1
    }
    return counts
  }

}
