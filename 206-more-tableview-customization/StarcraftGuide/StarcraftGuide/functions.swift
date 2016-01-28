//
//  functions.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

func groupBy<Type, MemberType>(collection: [Type], member: Type -> MemberType) -> [MemberType: [Type]] {
    var dict = [MemberType:[Type]]()
    for x in collection {
        let member = member(x)
        if dict[member] == nil {
            dict[member] = []
        }
        dict[member]!.append(x)
    }
    return dict
}
