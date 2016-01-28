//
//  TextFieldCell.swift
//  StarcraftGuide
//
//  Created by Ben Scheirman on 1/18/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class TextFieldCell : UITableViewCell {
    var label: UILabel!
    var textField: UITextField!

    init() {
        super.init(style: .Default, reuseIdentifier: nil)
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubviews()
    }
    
    func createSubviews() {
        let Margin: CGFloat = 16
        
        selectionStyle = .None
        if label == nil {
            label = UILabel()
            contentView.addSubview(label)
            label.font = UIFont.boldSystemFontOfSize(16)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor, constant: Margin).active = true
            label.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
            label.setContentHuggingPriority(1000, forAxis: .Horizontal)
            label.sizeToFit()
        }
        
        if textField == nil {
            textField = UITextField()
            contentView.addSubview(textField)
            textField.textAlignment = NSTextAlignment.Right
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.borderStyle = UITextBorderStyle.None
            textField.placeholder = "Enter a name"
            textField.leftAnchor.constraintEqualToAnchor(label.rightAnchor, constant: Margin).active = true
            textField.topAnchor.constraintEqualToAnchor(contentView.topAnchor).active = true
            textField.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor).active = true
            textField.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor, constant: -Margin).active = true
        }
    }
}
