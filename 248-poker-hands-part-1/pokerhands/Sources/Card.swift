struct Card: CustomStringConvertible {
  let value: CardValue
  let suit: Suit

  init?(value: CardValue?, suit: Suit?) {
    guard let value = value, let suit = suit else { return nil }
    self.value = value
    self.suit = suit
  }

  static func parse(_ string: String) -> Card? {
    guard string.characters.count == 2 else { return nil }
    let index = string.index(after: string.startIndex)
    let cardValue = CardValue(display: string.substring(to: index))
    let suit = Suit(rawValue: string.substring(from: index))
    return Card(value: cardValue, suit: suit)
  }

  var description: String {
    return "\(value)\(suit)"
  }
}

extension Card: Equatable {
  static func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.value == rhs.value && lhs.suit == rhs.suit
  }
}

extension Card: Comparable {
  static func <(lhs: Card, rhs: Card) -> Bool {
    return lhs.value < rhs.value
  }
}
