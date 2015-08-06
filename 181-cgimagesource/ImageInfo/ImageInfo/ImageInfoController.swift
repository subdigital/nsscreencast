//
//  ImageInfoController.swift
//  ImageInfo
//
//  Created by Ben Scheirman on 8/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit
import ImageIO


class ImageInfoController: UITableViewController {

    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var lensLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var fStopLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel!
    
    func updateWithImageProperties(properties: NSDictionary) {
        let info = ImageInfo(imageProperties: properties)
        cameraLabel.text = info.cameraModel
        lensLabel.text = info.lens
        fStopLabel.text = "\(info.fStop!)"
        isoLabel.text = "\(info.iso!)"
        widthLabel.text = "\(info.imageWidth!) px"
        heightLabel.text = "\(info.imageHeight!) px"
    }
}
