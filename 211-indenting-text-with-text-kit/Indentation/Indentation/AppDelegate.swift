//
//  AppDelegate.swift
//  Indentation
//
//  Created by Sam Soffes on 2/17/16.
//  Copyright © 2016 Nothing Magical, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow? = UIWindow()

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window?.rootViewController = UINavigationController(rootViewController: ViewController())
		window?.makeKeyAndVisible()
		return true
	}
}
