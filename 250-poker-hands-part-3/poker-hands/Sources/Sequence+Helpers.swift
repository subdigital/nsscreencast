extension Sequence {
  func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
    for e in self {
      if !predicate(e) {
        return false
      }
    }

    return true
  }
}
