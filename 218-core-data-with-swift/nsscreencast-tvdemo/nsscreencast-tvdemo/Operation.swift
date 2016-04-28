//
//  Operation.swift
//  NSScreencast
//
//  Created by Ben Scheirman on 10/22/15.
//  Copyright © 2015 Fickle Bits. All rights reserved.
//

import Foundation

class Operation : NSOperation {

    override var asynchronous: Bool {
        return true
    }

    private var _executing = false {
        willSet {
            willChangeValueForKey("isExecuting")
        }
        didSet {
            didChangeValueForKey("isExecuting")
        }
    }

    override var executing: Bool {
        return _executing
    }

    private var _finished = false {
        willSet {
            willChangeValueForKey("isFinished")
        }

        didSet {
            didChangeValueForKey("isFinished")
        }
    }

    override var finished: Bool {
        return _finished
    }

    override func start() {
        _executing = true
        execute()
    }

    func execute() {
        fatalError("You must override this")
    }

    func finish() {
        _executing = false
        _finished = true
    }
}
