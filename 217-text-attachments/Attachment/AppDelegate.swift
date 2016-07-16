//
//  AppDelegate.swift
//  Attachment
//
//  Created by Sam Soffes on 4/4/16.
//  Copyright © 2016 Sam Soffes. All rights reserved.
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
