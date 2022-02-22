//
//  ProfileUpdatePasswordViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class MembershipViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Membership"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        self.showPlaceholder(image: UIImage(systemName: "rectangle.stack.fill.badge.person.crop"),
                             text: "You don't have any\nsubscriptions at the moment")
    }
}
