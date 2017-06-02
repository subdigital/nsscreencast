//
//  Result.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
