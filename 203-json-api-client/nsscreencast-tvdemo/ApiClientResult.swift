//
//  ApiClientResult.swift
//  nsscreencast-tvdemo
//
//  Created by Ben Scheirman on 1/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation
import Argo

public enum ApiClientResult<T> {
    case Success(T)
    case Error(NSError)
    case NotFound
    case ServerError(Int)
    case ClientError(Int)
    case UnexpectedResponse(JSON)
}