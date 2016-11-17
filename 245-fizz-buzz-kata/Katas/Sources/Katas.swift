class FizzBuzz {
  func run(upTo number: Int) -> [String] {
    return (1...number).map(process)
  }

  func process(_ n: Int) -> String {
    let fizz = n % 3
    let buzz = n % 5

    switch (fizz, buzz) {
    case (0, 0): return "FizzBuzz"
    case (0, _): return "Fizz"
    case (_, 0): return "Buzz"
    default: return String(n)
    }
  }
}
