import Foundation

enum JSValue : Printable {
  case JSArray([JSValue])
  case JSObject( [ String : JSValue ] )
  case JSNumber(Double)
  case JSString(String)
  case JSBool(Bool)
  case JSNull()

  static func decode(data: NSData) -> JSValue? {
    var error: NSError?
    let options: NSJSONReadingOptions = .AllowFragments
    let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: options, error: &error)

    if let json: AnyObject = object {
      return make(json as NSObject)
    } else {
      println("Couldn't parse the json provided")
      return nil
    }
  }

  static func make(obj: NSObject) -> JSValue {
    switch obj {
      case let s as NSString: return .JSString(s)
      case let n as NSNumber: return .JSNumber(n.doubleValue)
      case let null as NSNull: return .JSNull()
      case let a as NSArray: return makeArray(a)
      case let d as NSDictionary: return makeObject(d)
      default:
        println("Unhandled type: <\(obj)>")
        abort()
    }
  }

  static func makeArray(array: NSArray) -> JSValue {
    var items = Array<JSValue>()
    for obj in array {
      let jsValue = make(obj as NSObject)
      items.append(jsValue)
    }

    return .JSArray(items)
  }

  static func makeObject(dict: NSDictionary) -> JSValue {
    var object = Dictionary<String, JSValue>()
    for (key, value) in dict {
      object[key as String] = make(value as NSObject)
    }
    return .JSObject(object)
  }

  var description: String {
    get {
      switch self {
        case .JSNull(): return "JSNull()"
        case let .JSBool(b): return "JSBool(\(b))"
        case let .JSString(s): return "JSString(\(s))"
        case let .JSNumber(n): return "JSNumber(\(n))"
        case let .JSObject(o): return "JSObject(\(o))"
        case let .JSArray(a): return "JSArray(\(a))"
      }
    }
  }
}

protocol JSONDecode {
  typealias J
  class func fromJSON(j: JSValue) -> J?
}

class JSInt: JSONDecode {
  typealias J = Int
  class func fromJSON(j: JSValue) -> Int? {
    switch j {
      case let .JSNumber(n):
        return Int(n)
      default:
        return nil
    }
  }
}

class JSString: JSONDecode {
  typealias J = String
  class func fromJSON(j: JSValue) -> String? {
    switch j {
      case let .JSString(s): return s
      default: return nil
    }
  }
}

class JSArray<A, B : JSONDecode where B.J == A> : JSONDecode {
  typealias J = [A]
  class func fromJSON(j: JSValue) -> [A]? {
    switch j {
      case let .JSArray(array):
        let mapped = array.map { B.fromJSON($0) }
        let results = compact(mapped)
        if results.count == mapped.count {
          return results
        } else {
          return nil
        }

      default: return nil
    }
  }
}

