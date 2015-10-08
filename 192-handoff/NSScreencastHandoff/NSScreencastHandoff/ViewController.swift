//
//  ViewController.swift
//  NSScreencastHandoff
//
//  Created by Ben Scheirman on 10/5/15.
//  Copyright © 2015 NSScreencast. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController, NSUserActivityDelegate {
    
    var playerVC: AVPlayerViewController?
    
    @IBAction func playEpisodeTapped(sender: AnyObject) {
        let videoURL = NSURL(string: "https://www.nsscreencast.com/episodes/187.mp4")!
        let asset = AVURLAsset(URL: videoURL)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        self.playerVC = playerVC
        
        let interval = CMTimeMakeWithSeconds(1, 1)
        player.addPeriodicTimeObserverForInterval(interval, queue: nil) { time in
            print("Time: \(CMTimeGetSeconds(time))")
            if let activity = playerVC.userActivity {
                activity.needsSave = true
            }
        }
        
        presentViewController(playerVC, animated: true) {
            let activity = NSUserActivity(activityType: "com.nsscreencast.videoplay")
            activity.title = "Watch episode 187"
            activity.userInfo = [
                "foo": "bar"
            ]
            activity.webpageURL = NSURL(string: "https://www.nsscreencast.com/episodes/187")!
            activity.delegate = self
            activity.becomeCurrent()
            
            playerVC.userActivity = activity
            player.play()
        }
    }
    
    /* The user activity will be saved (to be continued or persisted). The receiver should update the activity with current activity state.
    */
    func userActivityWillSave(userActivity: NSUserActivity) {
        
        if let time = playerVC?.player?.currentTime() {
            let seconds = Int(CMTimeGetSeconds(time))
            userActivity.addUserInfoEntriesFromDictionary([
                "startTime": "\(seconds)"
            ])
        }
    }
    
    /* The user activity was continued on another device.
    */
    func userActivityWasContinued(userActivity: NSUserActivity) {
        print("Was continued")
    }
}

