import Foundation

class Box<T> {
    var unbox: T
    init(_ value: T) {
        unbox = value
    }
}

enum Result<T> {
    case Success(Box<T>)
    case Error(String)
    
    func map<U>(transform: T -> U) -> Result<U> {
        switch self {
        case .Success(let value):
            return .Success(Box(transform(value.unbox)))
        case .Error(let error):
            return .Error(error)
        }
    }
    
}

struct Customer {
    var name: String
    var emails: [String]
}

var customers = [
    Customer(name: "Alice", emails: ["alice@aol.com"]),
    Customer(name: "Bob", emails: ["bob@msn.com", "bob@gmail.com"]),
    Customer(name: "Charlie", emails: ["c@example.com"])
    ]

func flatten<T>(array: [[T]]) -> [T] {
    return array.reduce([]) { $0 + $1 }
}

extension Array {
    func flatMap<U>(transform: T -> [U]) -> [U] {
        return flatten(self.map(transform))
    }
}

var emails = customers.flatMap { $0.emails }
emails
var counts = emails.map(countElements)
counts

// [[String]] -> [String]
// Result<Result<T>> -> Result<T>

func flatten<T>(result: Result<Result<T>>) -> Result<T> {
    switch result {
    case .Success(let box):
        switch box.unbox {
        case .Success(let value): return .Success(value)
        case .Error(let error): return .Error(error)
        }
    case .Error(let error): return .Error(error)
    }
}

extension Result {
    func flatMap<U>(transform: T -> Result<U>) -> Result<U> {
        return flatten(self.map(transform))
    }
}


func divide(x: Int, y: Int) ->  Result<Float> {
    if y < 0 {
        return .Error("divide by zero")
    } else {
        return .Success(Box(Float(x) / Float(y)))
    }
}

func compute(input: Float) -> Result<Float> {
    if input < 0 {
        return .Error("negative")
    }
    return .Success(Box(log(input)))
}

switch divide(12, 2).flatMap(compute) {
case .Success(let value): value.unbox
case .Error(let error): error
}
class Page {
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

func asJSON(data: NSData) -> Result<AnyObject> {
    var error: NSError?
    if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) {
        return .Success(Box(json))
    } else {
        return .Error("couldn't parse as JSON: \(error)")
    }
}

func asJSONArray(any: AnyObject) -> Result<NSArray> {
    if let array = any as? NSArray {
        return .Success(Box(array))
    } else {
        return .Error("wasn't an array")
    }
}

func secondElement(input: NSArray) -> Result<AnyObject> {
    if input.count >= 2 {
        return .Success(Box(input[1]))
    } else {
        return .Error("list only had \(input.count) elements")
    }
}

func asStringList(any: AnyObject) -> Result<[String]> {
    var list = [String]()
    if let array = any as? NSArray {
        for item in array {
            if let string = item as? String {
                list.append(string)
            } else {
                return .Error("Element \(item) was not a string")
            }
        }
        return .Success(Box(list))
    } else {
        return .Error("element \(any) was not an array")
    }
}

func asPages(contents: [String]) -> Result<[Page]> {
    let pages = map(contents) { Page(content: $0) }
    return .Success(Box(pages))
}




var json = "[ \"a\", [ \"page1\", \"page2\", \"page3\"] ]"
var data: NSData = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!


infix operator >>== {
associativity left
}

func >>==<T, U>(lhs: Result<T>, rhs: (T -> Result<U>)) -> Result<U> {
    return lhs.flatMap(rhs)
}


func pagesFromData(data: NSData) -> Result<[Page]> {
    //    let pages = asJSON(data)
    //        .flatMap(asJSONArray)
    //        .flatMap(secondElement)
    //        .flatMap(asStringList)
    //        .flatMap(asPages)
    
    let pages = asJSON(data)
        >>== asJSONArray
        >>== secondElement
        >>== asStringList
        >>== asPages
    
    return pages
}


switch pagesFromData(data) {
case .Success(let pages): pages.unbox
case .Error(let error): error
}


