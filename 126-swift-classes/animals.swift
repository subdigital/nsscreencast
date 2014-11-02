protocol Edible {
  var name: String { get }
  var value: Int { get }
}

struct Banana: Edible {
  var name: String { get { return "Banana" } }
  var value: Int { get { return 10 } }
}

struct DogTreat: Edible {
  var name: String { get { return "Dog Treat" } }
  var value: Int { get { return 5 } }
}


class Animal {
  let name: String
  var energy = 100

  init(name: String) {
    self.name = name
  }

  func makeSound() {
    energy -= 5
    printEnergy()
  }

  func eat(food: Edible) {
    println("[\(name) is eating a \(food.name) for \(food.value) energy]")
    energy += food.value
    printEnergy()
  }

  func printEnergy() {
    println("[\(name) now has \(energy) energy]")
  }
}

class Dog: Animal {
  override func makeSound() {
    println("Bark")
    super.makeSound()
  }
}

class Molly: Dog {
  init() {
    super.init(name: "Molly")
  }

  override func eat(food: Edible) {
    if let banana = food as? Banana {
      println("YUCK")
    } else {
      super.eat(food)
    }
  }
}

func play(animal: Animal) {
  println("Playing with \(animal.name)")
  animal.makeSound()
}

let dog = Dog(name: "Fido")
play(dog)
play(dog)
play(dog)
play(dog)

dog.eat(Banana())


Molly().eat(Banana())
Molly().eat(DogTreat())
