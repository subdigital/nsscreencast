//
//  NSURL+Decodable.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 4/24/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

extension NSURL: Decodable {
    public typealias DecodedType = NSURL
    
    public class func decode(j: JSON) -> Decoded<NSURL> {
        switch j {
        case .String(let urlString):
            return NSURL(string: urlString).map(pure) ?? .typeMismatch("URL", actual: j)
        default: return .typeMismatch("URL", actual: j)
        }
    }
}
