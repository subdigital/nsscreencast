import XCTest
@testable import pokerhands

class pokerhandsTests: XCTestCase {
  let input = "Black: 2H 3D 5S 9C KD  White: 2C 3H 4S 8C AH"

  func testParsesPlayers() {
    let parser = Parser(input: input)
    let players = parser.parse()
    XCTAssertEqual(2, players.count)
    XCTAssertEqual(["Black", "White"], players.map { $0.name })
  }

  func testParsesPlayerHands() {
    let parser = Parser(input: input)
    let players = parser.parse()
    let cards = players[0].cards
    XCTAssertEqual(5, cards.count)
    let expectedCards = [
      Card.parse("2H"),
      Card.parse("3D"),
      Card.parse("5S"),
      Card.parse("9C"),
      Card.parse("KD"),
    ].flatMap { $0 }
    XCTAssertEqual(expectedCards, cards)
  }

  func testParsesCards() {
    let cardString = "5H"
    let card = Card.parse(cardString)
    XCTAssertEqual(5, card?.value)
    XCTAssertEqual(Suit.hearts, card?.suit)
  }

  func testDetectsHighCard() {
    let cards = [ "2H", "3D", "5S", "9C", "KD" ]
    assertHand(cards, .highCard(13))
  }

  func testDetectsPair() {
    let cards = [ "2H", "2D", "5S", "9C", "KD" ]
    assertHand(cards, .pair(2))
  }

  func testDetectsThreeOfAKind() {
    let cards = [ "2H", "2D", "2S", "9C", "KD" ]
    assertHand(cards, .threeOfAKind(2))
  }

  func testDetectsFourOfAKind() {
    let cards = [ "2H", "2D", "2S", "2C", "KD" ]
    assertHand(cards, .fourOfAKind(2))
  }

  func testDetectsTwoPair() {
    let cards = [ "2H", "2D", "3S", "3C", "KD" ]
    assertHand(cards, .twoPair(3, 2))
  }

  func testFullHouse() {
    let cards = [ "2H", "2D", "3S", "3C", "3D" ]
    assertHand(cards, .fullHouse(3, 2))
  }

  func testStraight() {
    let cards = [ "2H", "3D", "6S", "5C", "4D" ]
    assertHand(cards, .straight(6))
  }

  func testFlush() {
    let cards = [ "2H", "5H", "JH", "TH", "AH"]
    assertHand(cards, .flush(.hearts, 14))
  }

  func testStraightFlush() {
    let cards = [ "2H", "3H", "5H", "4H", "6H"]
    assertHand(cards, .straightFlush(.hearts, 6))
  }

  func testRoyalFlush() {
    let cards = [ "TH", "JH", "QH", "KH", "AH"]
    assertHand(cards, .royalFlush(.hearts))
  }

  private func assertHand(_ cardStrings: [String], _ expectedHand: PokerHand) {
    let cards = cardStrings.flatMap(Card.parse)
    let hand = Poker(cards: cards).judge()
    XCTAssertEqual(hand, expectedHand)
  }
}
