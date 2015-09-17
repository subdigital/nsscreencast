let x = 1 + 2
var y: Int
let z: Float = 5.5

let name = "Ben"
let msg = "Hello, \(name)."

print(name)

var items = [1, 2, 3]
items.append(4)
items.removeAtIndex(0)
items.insert(10, atIndex: 0)
let a = items[0]

var mixed: [Any] = [1, false, "a"]
let b = mixed[0] as! Int


let slice = items[1..<3]

for (index, item) in items.enumerate() {
    print("Item (\(index)): \(item)")
}


var menu = [
    "queso" : 4.50,
    "tacos" : 6.00,
    "enchiladas": 8.95,
    "fajitas": 21.00
]

menu["chips"] = 1.00
menu["chips"] = nil

for (item, price) in menu {
    print("\(item) costs \(price)")
}

let max = 10
for x in 0...max {
    let v = x - max/2
    v * v
}


