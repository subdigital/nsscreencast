import Foundation

class Parser {
  let input: String

  init(input: String) {
    self.input = input
  }

  func parse() -> [Player] {
    let parts = input.components(separatedBy: "  ")
    return parts.map { part in
      let playerParts = part.components(separatedBy: ": ")
      let name = playerParts[0]
      let cardStrings = playerParts[1].components(separatedBy: " ")
      let cards = cardStrings.flatMap(Card.parse)
      return Player(name: name, cards: cards)
    }
  }
}
