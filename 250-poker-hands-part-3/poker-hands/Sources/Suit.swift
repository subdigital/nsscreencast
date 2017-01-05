enum Suit: String, CustomStringConvertible {
  case hearts = "H"
  case spades = "S"
  case diamonds = "D"
  case clubs = "C"

  var description: String {
    switch self {
    case .hearts: return "❤️"
    case .spades: return "♠️"
    case .diamonds: return "♦️"
    case .clubs: return "♣️"
    }
  }
}
