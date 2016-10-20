//
//  DownloadInfo.swift
//  FileDownloads
//
//  Created by Ben Scheirman on 10/18/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import Foundation
import CoreData

enum DownloadStatus : String {
    case Pending
    case Downloading
    case Paused
    case Failed
    case Completed
}

@objc(DownloadInfo)
class DownloadInfo : NSManagedObject {
    var status: DownloadStatus? {
        get {
            guard let value = statusValue else { return nil }
            return DownloadStatus(rawValue: value)
        }
        set {
            statusValue = status?.rawValue
        }
    }
    
    static var offlineLocation: URL {
        let docsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: docsDir).appendingPathComponent(".downloads", isDirectory: true)
    }
}
