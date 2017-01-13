//: Playground - noun: a place where people can play

import UIKit

class Updater {
    var block: (() -> Void)?
    
    func run(block: @escaping () -> Void) {
        self.block = block
    }
}

class Foo {
    var bar = ""
    
    func baz() {
        Updater().run {
            self.bar = "I was modified"
        }
    }
}


struct Person {
    let name: String
    let age: Int
}

let joe = Person(name: "Joe", age: 44)
print(joe)
dump(joe)

class Address {
    let streetAddress: String
    
    init(streetAddress: String) {
        self.streetAddress = streetAddress
    }
}

let addr = Address(streetAddress: "123 Any St.")
print(addr)
dump(addr)