//
//  UpdatePasswordViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class UpdatePasswordViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Update Password"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [getFormSection()])
    }
}

// MARK: - Form section
extension UpdatePasswordViewController {
    
    func getFormSection() -> DSSection {
        
        // Subtitle
        var description = DSLabelVM(.subheadline, text: "Changing your password regularly reduces your risk of exposure and avoids a number of dangers.")
        description.style.displayStyle = .grouped(inSection: false)
        
        // Password
        let currentPassword = DSTextFieldVM.password(placeholder: "Current Password")
        currentPassword.errorPlaceHolderText = "Min 8 chars max 14"
        
        // Password
        let password = DSTextFieldVM.newPassword(placeholder: "Password")
        password.errorPlaceHolderText = "Min 8 chars max 14"
        
        // Password
        let repeatPassword = DSTextFieldVM.newPassword(placeholder: "Repeat password")
        repeatPassword.errorPlaceHolderText = "Should match password"
        repeatPassword.handleValidation = { text in
            return text == password.text
        }
        
        // Update
        var updateButton = DSButtonVM(title: "Update")
        
        // Handle did tap on button
        updateButton.didTap = { [unowned self] model in
            
            self.isCurrentFormValid { isValid in
                if isValid {
                    self.show(message: "Your password was successfully updated",
                              type: .success,
                              timeOut: 1) {
                        self.update()
                    }
                }
            }
        }
        
        return [description,
                currentPassword,
                password,
                repeatPassword,
                updateButton].list()
    }
}
