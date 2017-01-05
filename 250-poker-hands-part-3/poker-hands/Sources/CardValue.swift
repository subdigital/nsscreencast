struct CardValue: ExpressibleByIntegerLiteral {
  let display: String
  let value: Int

  init(integerLiteral: Int) {
    self.value = integerLiteral
    switch value {
    case 2..<10: display = String(value)
    case 10: display = "T"
    case 11: display = "J"
    case 12: display = "Q"
    case 13: display = "K"
    case 14: display = "A"
    default: fatalError("value \(integerLiteral) out of bounds for cardValue")
    }
  }

  init?(display: String) {
    guard display.characters.count == 1 else { return nil }
    self.display = display
    switch display {
    case "T": value = 10
    case "J": value = 11
    case "Q": value = 12
    case "K": value = 13
    case "A": value = 14
    default:
      if let digit = Int(display) {
        value = digit
      } else {
        return nil
      }
    }
  }

}

extension CardValue: Equatable {
  static func ==(lhs: CardValue, rhs: CardValue) -> Bool {
    return lhs.value == rhs.value
  }
}

extension CardValue: CustomStringConvertible {
  var description: String {
    return display
  }
}

extension CardValue: Comparable {
  static func <(lhs: CardValue, rhs: CardValue) -> Bool {
    return lhs.value < rhs.value
  }
}

extension CardValue : Hashable {
  var hashValue: Int {
    return value
  }
}
