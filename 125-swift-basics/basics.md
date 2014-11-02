### Expressions

Using the swift REPL, you can type expressions to have them evaluated.

```
1 + 2
> $R1: Int = 2
```

### Variables

You can declare variables inline with the `var` keyword.

```
var x = 30
> x: Int = 30
```

Note how `x` is of type `Int` because we initialized it with an integer.  You can 
also declare variables as constants, meaning their values cannot change.

```
let y = 50
> y: Int = 50
```

Here `y` is also an `Int`, however you cannot set `y` to a new value since it is declared with `let`.

If you don't specify an initial value, you must declare the type of variable, like this:

```
var count: Int
# count: Int: 0
```

`count` received the default value for `Int` variables because we did not specify one.

You can work `Double`s similarly:

```
var price: 0.5
# price: Double = 0.5

var subTotal: Double
# subtotal: Double = 0.0
```

### Strings and Characters

Strings are easy to work with in Swift.

```
var string = "hello"
var letter: Character = "A"
```

You can index strings just like arrays, and any `NSString` methods just work like they did before.

### Arrays

You can declare arrays with square brackets:

```
var items = [1, 3, 4]
# items: [Int] = size=3 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
# }
```

You can append items to an array:

```
items.append(6)
# items: [Int] = size=4 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
#   [3] = 6
# }
```

... and even append other arrays...

```
items += [7, 8]
# items: [Int] = size=3 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
#   [3] = 6
#   [4] = 7
#   [5] = 8
# }
```

#### Using Let with arrays

```
let items = ["Apple", "Banana"]
```
`items` is now an immutable array.  It's elements can not be changed, nor can elements be added or removed.

```
items[0] = "Cherry"
```

Slicing arrays

```
var numbers = [ "a", "b", "c", "d", "e", "f", "g" ]
numbers[0..<2]
#  [String] = size=2 {
#    [0] = "a"
#    [1] = "b"  
#  }
#
```

If you want the range to include the last value, then you use `...` like this:

```
var numbers = [ "a", "b", "c", "d", "e", "f", "g" ]
numbers[0...2]
#  [String] = size=3 {
#    [0] = "a"
#    [1] = "b"  
#    [2] = "c"
#  }
#
```

### Dictionaries

```
var gradebook = [ "Al": "A", "Joe": "B", "Charlie": "D" ]
gradebook["Charlie"] 
#> String? = "D"
```

Checking to see if values exist in the dictionary:

```
if let grade = gradebook["Ben"] {
  // doesn't get called
}

if let grade = gradebook["Al"] {
  println("The grade is \(grade)")
}
```

### Looping

Arrays:

```
for item in items {
  println("The item is \(item)")
}
```

Dictionaries:

```
for (student, grade) in gradebook {
  println("\(student) has a \(grade)")
}
```
