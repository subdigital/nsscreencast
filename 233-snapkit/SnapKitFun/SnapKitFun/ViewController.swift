//
//  ViewController.swift
//  SnapKitFun
//
//  Created by Ben Scheirman on 8/22/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var avatar: UIImageView!
    var expandedAvatar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
        view.backgroundColor = .whiteColor()
        
        let navbar = UIView()
        navbar.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        view.addSubview(navbar)
        navbar.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(64)
        }
        
        let title = UILabel()
        title.font = UIFont.boldSystemFontOfSize(16)
        title.text = "Profile"
        title.textAlignment = .Center
        title.textColor = .darkGrayColor()
        navbar.addSubview(title)
        title.snp_makeConstraints { make in
            make.center.equalTo(navbar).offset(CGPointMake(0, 10))
        }
        
        let tabbar = UIView()
        tabbar.backgroundColor = navbar.backgroundColor
        view.addSubview(tabbar)
        tabbar.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
            make.height.equalTo(64)
        }
        
        let topSection = UIView()
        topSection.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.addSubview(topSection)
        topSection.snp_makeConstraints { make in
            make.top.equalTo(navbar.snp_bottom)
            make.left.equalTo(self.view.snp_left)
            make.right.equalTo(self.view.snp_right)
        }
        
        avatar = UIImageView(image: UIImage(named: "calvincandie"))
        avatar.userInteractionEnabled = true
        avatar.clipsToBounds = true
        topSection.addSubview(avatar)
        avatar.snp_makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(avatar.snp_height)
            
            let insets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            make.top.equalTo(topSection.snp_top).inset(insets)
            make.left.equalTo(topSection.snp_left).inset(insets)
            make.bottom.equalTo(topSection.snp_bottom).inset(insets)
        }
        topSection.layoutIfNeeded()
        avatar.layer.cornerRadius = CGRectGetHeight(avatar.bounds) / 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.onAvatarTap))
        avatar.addGestureRecognizer(tap)
        
        let nameLabel = UILabel()
        nameLabel.text = "Calvin Candie"
        nameLabel.textColor = .darkGrayColor()
        nameLabel.font = UIFont.boldSystemFontOfSize(16)
        
        let handleLabel = UILabel()
        handleLabel.text = "@calvincandie"
        handleLabel.textColor = view.tintColor
        handleLabel.font = UIFont.systemFontOfSize(15)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, handleLabel])
        labelStack.axis = .Vertical
        labelStack.distribution = .FillProportionally
        labelStack.alignment = .Leading
        
        topSection.addSubview(labelStack)
        labelStack.snp_makeConstraints { make in
            make.leading.equalTo(avatar.snp_trailing).offset(12)
            make.centerY.equalTo(topSection.snp_centerY)
        }
        
        let followButton = UIButton(type: .System)
        followButton.backgroundColor = .whiteColor()
        
        followButton.setTitle("Follow", forState: .Normal)
        followButton.titleLabel?.font = UIFont.boldSystemFontOfSize(9)
        topSection.addSubview(followButton)
        followButton.snp_makeConstraints { make in
            make.centerY.equalTo(0)
            make.right.equalTo(topSection.snp_rightMargin).offset(-10)
            make.width.equalTo(64)
        }
        topSection.layoutIfNeeded()
        followButton.layer.cornerRadius = CGRectGetHeight(followButton.bounds) / 2.0
        
        
    }
    
    func onAvatarTap() {
        expandedAvatar = !expandedAvatar
        avatar.snp_updateConstraints { update in
            update.height.equalTo(expandedAvatar ? 100 : 50)
        }
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { 
            self.avatar.superview?.layoutIfNeeded()
            }, completion: nil)
    }
    
}

