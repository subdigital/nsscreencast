import Frank
import Foundation

get { request in
  return "Hello World"
}

get("users", *) { (request, username: String) in
  stencil("index.stencil", ["username": username])
}

get("api") { request in
  return renderJSON(["date": "\(NSDate())"])
}
