//
//  UIViewController+Storyboards.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/23/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle? { get }
    static var storyboardIdentifier: String { get }
    
    static func makeFromStoryboard() -> Self
    
    func wrapWithNavigationController(navigationBarClass: AnyClass?) -> UINavigationController
}

extension StoryboardInitializable where Self : UIViewController {
    static var storyboardName: String {
        return "Main"
    }
    
    static var storyboardBundle: Bundle? {
        return nil
    }
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func makeFromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        if let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self {
            return vc
        } else {
            fatalError("Could not instantiate \(self) from Storyboard (\(storyboardName)) with identifier '\(storyboardIdentifier)'")
        }
    }
    
    func wrapWithNavigationController(navigationBarClass: AnyClass? = nil) -> UINavigationController {
        let nav = UINavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
        nav.viewControllers = [self]
        return nav
    }
}
