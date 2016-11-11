//
//  NetworkClient.swift
//  WidgetFactory
//
//  Created by Ben Scheirman on 11/8/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation

class NetworkClient {
    func get(url: URL) {
        log.info("HTTP GET to \(url)")
    }
    
    func post(url: URL, params: [String: Any]) {
        log.info("HTTP POST to \(url)")
        log.debug("Params: \(params)")
    }
}
