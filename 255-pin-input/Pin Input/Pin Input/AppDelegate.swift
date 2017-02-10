//
//  AppDelegate.swift
//  Pin Input
//
//  Created by Sam Soffes on 1/22/17.
//  Copyright © 2017 Sam Soffes. All rights reserved.
//

import UIKit

@UIApplicationMain final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow? = {
		let window = UIWindow()
		window.rootViewController = UINavigationController(rootViewController: ViewController())
		return window
	}()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}
