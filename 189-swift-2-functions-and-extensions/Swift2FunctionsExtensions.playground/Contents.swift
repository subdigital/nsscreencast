
func greetWithName(name: String, _ suffix: String) -> String {
    return "Hello, \(name)\(suffix)"
}

let greeting = greetWithName("Ben", "!")


func minMax(array: [Int]) -> (min: Int, max: Int)? {
    guard !array.isEmpty else {
        return nil
    }
    
    var min = array[0]
    var max = array[0]
    
    for item in array[1..<array.count] {
        if item > max {
            max = item
        }
        
        if item < min {
            min = item
        }
    }
    
    return (min, max)
}

if let (min2, max2) = minMax([1,10,-2,44,3]) {
    min2
    max2
}


func printMessage(msg: String, times: Int) {
    for _ in 0..<times {
        print(msg)
    }
}

printMessage("Ho", times: 3)



func doSomething(n: Int) {
    print("Ho")
}

extension Int {
    func times(block: (Int) -> ()) {
        for n in 0..<self {
            block(n)
        }
    }
}

15.times {
   print("Hi, \($0)")
}



