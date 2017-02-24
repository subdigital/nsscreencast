//
//  NotificationPrompt.swift
//  BeerButton
//
//  Created by Dory Glauberman on 2/1/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//

import UIKit

protocol NotificationPromptDelegate: class {

    func didAllowNotificationPrompt(_ allowed: Bool)
}

class NotificationPrompt: UIView {

    weak var delegate: NotificationPromptDelegate?

    @IBAction func notNowPressed(_ sender: Any) {
        delegate?.didAllowNotificationPrompt(false)
    }

    @IBAction func allowPressed(_ sender: Any) {
        delegate?.didAllowNotificationPrompt(true)
    }
}
