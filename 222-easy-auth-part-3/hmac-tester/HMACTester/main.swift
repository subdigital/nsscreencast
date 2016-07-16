//
//  main.swift
//  HMACTester
//
//  Created by Ben Scheirman on 5/9/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)

let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
let buffer = UnsafeMutablePointer<UInt8>.alloc(digestLength)

let key = "abcd1234"
let data = "dffed4f392b6745631bc867b8207b36005c90cb80c53c10c"

CCHmac(algorithm, key, key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
       data, data.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
       buffer)

var str = ""
for i in 0..<digestLength {
    str = str.stringByAppendingFormat("%x", buffer[i])
}

print("Result: \(str)")
