//
//  UIViewController+Alerts.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func promptForValue(title: String?, message: String?, placeholder: String?, buttonTitle: String = "OK", completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = placeholder
        }
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { [weak alert] (action) in
            
            guard let textField = alert?.textFields?.first else {
                fatalError("No text fields found in alert")
            }
            
            completion(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
