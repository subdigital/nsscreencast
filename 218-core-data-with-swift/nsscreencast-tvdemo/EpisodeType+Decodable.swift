//
//  EpisodeType+Decodable.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/11/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

extension EpisodeType : Decodable {
    typealias DecodedType = EpisodeType
    
    static func decode(json: JSON) -> Decoded<EpisodeType> {
        switch json {
        case .String(let str):
            if let type = EpisodeType(rawValue: str) {
                return .Success(type)
            } else {
                return .Failure(DecodeError.TypeMismatch(expected: "either 'free' or 'paid'", actual: str))
            }
        default:
            return .Failure(DecodeError.TypeMismatch(expected: "String", actual: "\(json)"))
        }
    }
}