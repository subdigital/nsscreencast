//
//  NilCoalescingAssignment.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/23/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

infix operator ??= : AssignmentPrecedence

func ??=<T>( lhs: inout T?, defaultValue: @autoclosure () -> T?) {
    if lhs == nil { return }
    lhs = defaultValue()
}
