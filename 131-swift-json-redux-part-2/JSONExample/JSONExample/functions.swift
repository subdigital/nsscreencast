func compact<T>(collection: [T?]) -> [T] {
  return filter(collection) {
    if $0 != nil {
      return true
    } else {
      return false
    }
  }.map { $0! }
}

func >>><A, B>(source: A?, f: A -> B?) -> B? {
  if source != nil {
    return f(source!)
  } else {
    return nil
  }
}
