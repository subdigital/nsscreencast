import Foundation

struct Dice {
  static func roll(_ count: Int) -> [Int] {
    return (0..<count).map { _ in
      return Int(arc4random_uniform(6)) + 1
    }
  }

  static func counts(_ dice: [Int]) -> [Int: Int] {
    var counts: [Int: Int] = [:]
    dice.forEach {
      counts[$0] = (counts[$0] ?? 0) + 1
    }
    return counts
  }
}

protocol Pattern {
  func matches(_ dice: [Int]) -> Bool
  func score(_ dice: [Int]) -> Int
}

struct Singles : Pattern {
  let pip: Int

  func matches(_ dice: [Int]) -> Bool {
    return findMatchingPips(dice).count > 0
  }

  func score(_ dice: [Int]) -> Int {
    return findMatchingPips(dice).reduce(0, +)
  }

  private func findMatchingPips(_ dice: [Int]) -> [Int] {
    return dice.filter { $0 == self.pip }
  }
}

protocol Repetition : Pattern {
  var minimum: Int { get }
}

protocol SumScore {}
extension SumScore where Self : Pattern {
  func score(_ dice: [Int]) -> Int {
    return matches(dice) ? dice.reduce(0, +) : 0
  }
}

extension Repetition {
  func matches(_ dice: [Int]) -> Bool {
      return Dice.counts(dice).filter({ _, count in count >= minimum }).first != nil
  }
}

struct ThreeOfAKind : Repetition, SumScore {
  var minimum: Int { return 3 }
}

struct FourOfAKind : Repetition, SumScore {
  var minimum: Int { return 4 }
}

protocol StaticScore {
  var possibleScore: Int { get }
}
extension StaticScore where Self : Pattern {
  func score(_ dice: [Int]) -> Int {
    return matches(dice) ? possibleScore : 0
  }
}

struct Yahtzee : Repetition, StaticScore {
  var minimum: Int { return 5 }
  var possibleScore: Int { return 50 }
}

protocol Sequence : Pattern {
  var minimum: Int { get }
}

func largestSequence(values: [Int]) -> Int {
  guard let head = values.first else { return 0 }
  let initial: (current: Int, best: Int, prev: Int) = (1, 1, head)
  let result = values.dropFirst().reduce(initial) { acc, el in
    let current = el - acc.prev == 1 ? acc.current + 1 : 1
    let best = max(current, acc.best)
    return (current, best, el)
  }
  return result.best
}

extension Sequence where Self : Pattern {
  func matches(_ dice: [Int]) -> Bool {
    return largestSequence(values: dice) >= minimum
  }
}

struct SmallStraight : Sequence, StaticScore {
  var possibleScore: Int { return 30 }
  var minimum: Int { return 4 }
}

struct LargeStraight : Sequence, StaticScore {
  var possibleScore: Int { return 40 }
  var minimum: Int { return 5 }
}

struct FullHouse : Pattern, StaticScore {
  var possibleScore: Int { return 25 }

  func matches(_ dice: [Int]) -> Bool {
    let counts = Dice.counts(dice)
    let hasMult: (Int) -> Bool = { c in
       return counts.filter {$1 == c}.count > 0
    }
    return hasMult(3) && hasMult(2)
  }
}
