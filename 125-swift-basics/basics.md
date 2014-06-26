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

var price: 0.5
# price: Double = 0.5

var subTotal: Double
# subtotal: Double = 0.0
```

### Strings and Characters

```
var string = "hello"
var letter: Character = "A"
```

### Collections

```
var items = [1, 3, 4]
# items: Int[] = size=3 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
# }

items += 6
# items: Int[] = size=4 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
#   [3] = 6
# }

items += [7, 8]
# items: Int[] = size=3 {
#   [0] = 1
#   [1] = 3
#   [2] = 4
#   [3] = 6
#   [4] = 7
#   [5] = 8
# }
```

Using Let with arrays

```
let items = ["Apple", "Banana"]
```
`items` size cannot change, but you can change elements in the array:

```
items[0] = "Cherry"
```

Slicing arrays

```
var numbers = [ "a", "b", "c", "d", "e", "f", "g" ]
numbers[0..2]
#  String[] = size=2 {
#    [0] = "a"
#    [1] = "b"  
#  }
#
```

If you want the range to include the last value, then you use `...` like this:

```
var numbers = [ "a", "b", "c", "d", "e", "f", "g" ]
numbers[0...2]
#  String[] = size=3 {
#    [0] = "a"
#    [1] = "b"  
#    [2] = "c"
#  }
#
```

### Dictionaries

```
var gradebook = [:]
```

