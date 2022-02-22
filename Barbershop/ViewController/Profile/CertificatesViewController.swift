//
//  ProfileUpdatePasswordViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class CertificatesViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Certificates"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        self.showPlaceholder(image: UIImage(systemName: "doc.text.fill"),
                             text: "You don't have any\ncertificates at the moment")
    }
}
