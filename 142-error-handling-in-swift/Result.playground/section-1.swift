

import Foundation

var jsonString = "{ \"foo\": \"bar\" }"
var data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!

var error: NSError?
var json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: &error)

if json != nil {
    json
} else {
    error
}

class Box<T> {
    var unbox: T
    init(_ value: T) {
        unbox = value
    }
}

enum Result<T> {
    case Success(Box<T>)
    case Error(String)
}


func divide(x: Int, y: Int) -> Result<Float> {
    if y == 0 {
        return .Error("divide by zero")
    } else {
        return .Success(Box(Float(x) / Float(y)));
    }
}


func compute(input: Result<Float>) -> Result<Float> {
    switch input {
    case .Success(let inputValue):
        if inputValue.unbox < 0 {
            return .Error("can't work with negative numbers")
        }
        return .Success(Box(log(inputValue.unbox)))

    case .Error: return input
    }
}

switch compute(divide(12, -4)) {
case .Success(let value): value.unbox
case .Error(let error): error
}



