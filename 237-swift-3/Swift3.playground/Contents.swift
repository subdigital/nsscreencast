//: Playground - noun: a place where people can play

import Foundation
import UIKit

// Consistent argument labels

func downloadEpisodeWithId(_ id: Int, options: [String: Any]? = nil) {
    
}

downloadEpisodeWithId(5)


// No ++ or -- operators

var x = 5
x += 1
x -= 1

// No traditional for loops

for a in 0..<10 {
    
}

(0..<10).forEach { a in
    
}


// No var function arguments

func makeImportant(string: String) -> String {
    var s = string
    s.append("!")
    return s
}
print(makeImportant(string: "Swift 3"))


// #keyPath   #selector

class Food : NSObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class FoodObserver : NSObject {
    init(food: Food) {
        super.init()
        food.addObserver(self, forKeyPath: #keyPath(Food.name), options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("change: \(change)")
    }
}

let food = Food(name: "Hot Dog")
let observer = FoodObserver(food: food)
food.name = "Hamburger"


// M_PI = .pi

let r = 5.0
let area = 2.0 * Double.pi * r


// NS prefix
// https://github.com/apple/swift-evolution/blob/bea5eab614b954775754639fb83a957a180152e1/proposals/0086-drop-foundation-ns.md


let dictionary: [String : Any] = [
    "food" : "hotdog",
    "amount": 1.99,
    "quantity": 4,
    "toppings": ["ketchup", "sourkraut", "relish"]
]
let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
let json = String(data: data, encoding: String.Encoding.utf8)!
print(json)


// Swift Naming Guidelines
// https://swift.org/documentation/api-design-guidelines/

// 1. Clarity at the point of use
// - avoid ambiguity with words
// - omit needless words
// 2. Clarity > Brevity

Bundle.main
FileManager.default
NotificationCenter.default
let shoppingList = ["apples", "bananas", "cherries"]
let list = shoppingList.joined(separator: ",")
let backToArray = list.components(separatedBy: ",")


// GCD (libdispatch)

DispatchQueue.main.async {
    print("running on the main queue")
}

let queue = DispatchQueue(label: "com.nsscreencast.awesomequeue", qos: DispatchQoS.default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
queue.sync {
    print("doing work on my queue")
}
