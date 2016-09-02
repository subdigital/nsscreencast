//
//  Episode.swift
//  SharedWebCredentialsDemo
//
//  Created by Ben Scheirman on 8/30/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import Foundation

struct Episode {
    let id: Int
    let title: String
    let desc: String
    let imageURL: NSURL
    
    var path: String {
        return "/episodes/\(id)"
    }
}

let imageWidth = 200
let imageHeight = 120

let SampleEpisodes = [
    Episode(id: 203,
            title: "CAReplicatorLayer",
            desc: "In this episode we take our missile animation from last time and update it to use CAAnimations. Using these animations we can add a wiggle, along with a small oscillating rotation to give a little life to the missile. Then we utilize CAReplicatorLayer to have them fan out and fire in slightly different directions.",
            imageURL: NSURL(string: "https://nsscreencast.imgix.net/196-careplicatorlayer/196-careplicatorlayer.png?w=\(imageWidth)&h=\(imageHeight)&fit=crop")!
        ),
    
    Episode(id: 50,
            title: "In App Purchases",
            desc: "In this episode I dive into the world of IAP (In App Purchases) using StoreKit.  I start by creating a product in iTunes Connect, retrieving that product on the device, and emulating the App Store buy confirmation buttons using a handy CocoaPod.",
        imageURL: NSURL(string: "https://nsscreencast.imgix.net/044-in-app-purchases/044-in-app-purchases-poster@2x.png?w=\(imageWidth)&h=\(imageHeight)&fit=crop")!
    )
]