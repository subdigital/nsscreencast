//
//  main.swift
//  HMACTester
//
//  Created by NSScreencast on 5/17/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA1)

let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
let buffer = UnsafeMutablePointer<UInt8>.alloc(digestLength)

let data = "558e79f580baf895e4f1d002071a87604bb9ed7d4f780ecd"
let key = "abcd1234"

CCHmac(algorithm, key,
       key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
       data,
       data.lengthOfBytesUsingEncoding(NSUTF8StringEncoding),
       buffer)

var str = ""
for i in 0..<digestLength {
   let char = buffer[i]
    str = str.stringByAppendingFormat("%x", char)
}

print("Result: \(str)")


