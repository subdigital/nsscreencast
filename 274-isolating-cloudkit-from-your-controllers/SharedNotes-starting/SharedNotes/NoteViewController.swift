//
//  NoteViewController.swift
//  SharedNotes
//
//  Created by Ben Scheirman on 5/16/17.
//  Copyright © 2017 NSScreencast. All rights reserved.
//

import UIKit

final class NoteViewController : UIViewController, StoryboardInitializable {
    
    var notesManager: NotesManager!
    
    @IBOutlet weak var textView: UITextView!
    
    var note: Note!
    var changed = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note.content
        textView.becomeFirstResponder()
    
        setupNotifications()
        
    }
    
    private func setupNotifications() {
        let notifications = NotificationCenter.default
        notifications.addObserver(self, selector: #selector(textChanged), name: .UITextViewTextDidChange, object: textView)
        notifications.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        notifications.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard changed else {
            return
        }
        
        save(note: note)
    }
    
    private func save(note: Note) {
        print("Saving note...")
        notesManager.save(note: note) { result in
            // TODO: handle failed saves (retry?  queue for later?)
            
            // notify delegate
        }
    }
 
    func textChanged() {
        changed = true
        note.content = textView.text
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame: CGRect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Float else {
            print("Keyboard notification did not contain frame info")
            return
        }
        
        adjustBottomInsets(frame.size.height, animationDuration: duration)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Float else {
                print("Keyboard notification did not contain user info")
                return
        }
        
        let defaultMargin: CGFloat = 16
        adjustBottomInsets(defaultMargin, animationDuration: duration)
    }
    
    func adjustBottomInsets(_ bottom: CGFloat, animationDuration: Float = 0) {
        UIView.animate(withDuration: 2.0) { 
            self.textView.contentInset.bottom = bottom
            self.textView.scrollIndicatorInsets.bottom = bottom
        }
    }
}
