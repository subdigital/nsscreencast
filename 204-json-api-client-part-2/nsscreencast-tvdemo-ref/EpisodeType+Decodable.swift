//
//  EpisodeType+Decodable.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/10/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

extension EpisodeType : Decodable {
    typealias DecodedType = EpisodeType
    
    static func decode(json: JSON) -> Decoded<EpisodeType> {
        switch json {
        case .String(let stringValue):
            if let type = EpisodeType(rawValue: stringValue) {
                return .Success(type)
            } else {
                return .Failure(DecodeError.Custom("Unknown value: \(stringValue)"))
            }
        default:
            return .Failure(DecodeError.TypeMismatch(expected: "String", actual: "\(json)"))
        }
    }
}