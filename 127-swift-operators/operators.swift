import Foundation

class Regex {
  let pattern: String

  init(_ pattern: String) {
    self.pattern = pattern
  }

  func test(input: String) -> Bool {
    let range = input.rangeOfString(pattern, options: .RegularExpressionSearch)
    return range != nil
  }
}

infix operator =~ {}

func =~(input: String, pattern: String) -> Bool {
  return Regex(pattern).test(input)
}

/*let input = "09182a4"*/
/*if input =~ "^\\d+$" {*/
/*  println("Matches")*/
/*} else {*/
/*  println("doesn't match")*/
/*}*/


struct Vector {
  let x: Float
  let y: Float

  func dotProduct(other: Vector) -> Float {
    return x * other.x + y * other.y
  }
}

let a = Vector(x: 1, y: 8)
let b = Vector(x: 6, y: 2)

infix operator .. {}

func ..(a: Vector, b: Vector) -> Float {
  return a.dotProduct(b)
}

let result = a .. b



println("The dot product is \(result)")
