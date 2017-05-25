//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Ben Scheirman on 5/23/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

final class NoteViewController : UIViewController, StoryboardInitializable {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Note #251"
    }
}
