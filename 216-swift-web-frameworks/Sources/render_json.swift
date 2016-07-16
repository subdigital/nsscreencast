import Frank
import Foundation
import Inquiline
import Jay

func renderJSON(object: Any, status: Status = .Ok) -> ResponseConvertible {
  do {
    let headers = [("Content-Type", "application/json")]

    let jsonData = try Jay().dataFromJson(object)
    let json = try jsonData.string()

    return Response(status, headers: headers, body: json)
  } catch {
    print("Error serializing \(object) to JSON")
    return Response(.InternalServerError)
  }
}
