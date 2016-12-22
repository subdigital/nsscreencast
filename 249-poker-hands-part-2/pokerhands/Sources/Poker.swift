enum PokerHand {
case highCard(CardValue)
case pair(CardValue)
}

struct Poker {
  let cards: [Card]

  init(cards: [Card]) {
    self.cards = cards
  }

  func judge() -> PokerHand? {
    let orderedHands: [ (Void) -> PokerHand? ] = [
      pair, highCard
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

  private func findRepeated(count repetitionCount: Int) -> CardValue? {
    let counts = computeCounts()
    if let (cardValue, _) = counts.first(where: { (cardValue, count) in
        return count == repetitionCount
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
