//
//  SelectRaceViewController.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class SelectRaceViewController : UIViewController {
    
    var raceSelectionBlock: (Race->Void)? = nil
    
    @IBAction func protossSelected(sender: UIButton) {
        raceSelectionBlock?(Race.Protoss)
    }

    @IBAction func zergSelected(sender: UIButton) {
        raceSelectionBlock?(Race.Zerg)
        
    }

    @IBAction func terranSelected(sender: UIButton) {
        raceSelectionBlock?(Race.Terran)
    }
}
