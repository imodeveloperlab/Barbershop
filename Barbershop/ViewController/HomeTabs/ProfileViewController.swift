//
//  ProfileViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class ProfileViewController: DSViewController {
    
    enum ProfileViewControllerSegments: Int {
        case login
        case sms
    }
    
    var formEmailValue: String?
    var formPasswordValue: String?
    var formPhoneNumberValue: String?
    var currentFormSectionIndex: ProfileViewControllerSegments = .login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        if BookingManager.shared.authorized {
            
            // Show authorized user sections
            self.show(content: [getProfileSettingsSection(),
                                getGeographySection(),
                                getMemberShipSection(),
                                getLogOutSection()])
        } else {
            
            // Show unauthorized user sections
            let authenticationForm: DSSection = (currentFormSectionIndex == .login ? getLoginAuthorizationSection() : getSmsAuthorizationSection())
            
            self.show(content: [getSwitchAuthenticationModesSection(),
                                authenticationForm,
                                getGuestUserProfileSection()])
        }
    }
}

// MARK: - Switch authentication modes
extension ProfileViewController {
    
    func getSwitchAuthenticationModesSection() -> DSSection {
        
        let segment = DSSegmentVM(segments: ["Login", "SMS Authorization"])
        
        segment.didTapOnSegment = { segment in
            self.currentFormSectionIndex = ProfileViewControllerSegments(rawValue: segment.index) ?? .login
            
            // Call update to show changes
            self.update()
        }
        
        return [segment].list()
    }
}

// MARK: - Loged In User
extension ProfileViewController {
    
    /// Get profile geography sections
    /// - Returns: DSSection
    func getGeographySection() -> DSSection {
        
        let header = DSLabelVM(.subheadline, text: "Geography")
        
        var changeLocation = action(title: "Change location", leftSymbol: "location.fill")
        changeLocation.didTap { [unowned self] (_ : DSActionVM) in
            let vc = ChangeLocationViewController()
            self.push(vc)
        }
        
        var changeLanguage = action(title: "Change language", leftSymbol: "textformat.alt")
        changeLanguage.didTap { [unowned self] (_ : DSActionVM) in
            let vc = ChangeLanguageController()
            self.push(vc)
        }
        
        return [header, changeLocation, changeLanguage].list()
    }
    
    /// Get membership section
    /// - Returns: DSSection
    func getMemberShipSection() -> DSSection {
        
        let header = DSLabelVM(.subheadline, text: "Membership")
        
        var loyaltyCards = action(title: "Loyalty Cards", leftSymbol: "rectangle.fill")
        loyaltyCards.didTap { [unowned self] (_ : DSActionVM) in
            let vc = LoyaltyCardsViewController()
            self.push(vc)
        }
        
        var membership = action(title: "Membership", leftSymbol: "person.2.fill")
        membership.didTap { [unowned self] (_ : DSActionVM) in
            let vc = MembershipViewController()
            self.push(vc)
        }
        
        var certificates = action(title: "Certificates", leftSymbol: "rectangle.stack.fill.badge.person.crop")
        certificates.didTap { [unowned self] (_ : DSActionVM) in
            let vc = CertificatesViewController()
            self.push(vc)
        }
        
        return [header, loyaltyCards, membership, certificates].list()
    }
    
    /// Profile settings section
    /// - Returns: DSSection
    func getProfileSettingsSection() -> DSSection {
        
        // User profile
        let person = DSFaker().person
        var profile = person.viewModel()
        profile.style.displayStyle = .grouped(inSection: false)
        profile.object = person as AnyObject
        
        //Handle did tap on profile
        profile.didTap { [unowned self] (_ : DSActionVM) in
            let vc = ProfileDetailsViewController()
            self.push(vc)
        }
        
        var notifications = action(title: "Notifications", leftSymbol: "bell.fill")
        notifications.didTap { [unowned self] (_ : DSActionVM) in
            let vc = NotificationsViewController()
            self.push(vc)
        }
        
        var passwordUpdate = action(title: "Password Update", leftSymbol: "lock.fill")
        passwordUpdate.didTap { [unowned self] (_ : DSActionVM) in
            let vc = UpdatePasswordViewController()
            self.push(vc)
        }
        
        return [profile, notifications, passwordUpdate].list()
    }
    
    /// Log out section
    /// - Returns: <#description#>
    func getLogOutSection() -> DSSection {
        
        var button = DSButtonVM(title: "Log out")
        
        button.didTap { [unowned self] (_: DSButtonVM) in
            
            BookingManager.shared.authorized = false
            
            self.show(message: "Log out", timeOut: 2) {
                self.update()
            }
        }
        
        return [button].list()
    }
}

// MARK: - Guest User
extension ProfileViewController {
    
    /// Guest user profile section
    /// - Returns: DSSection
    func getGuestUserProfileSection() -> DSSection {
        
        var certificates = action(title: "Certificates", leftSymbol: "rectangle.stack.fill.badge.person.crop")
        
        certificates.didTap { [unowned self] (_ : DSActionVM) in
            let vc = CertificatesViewController()
            self.push(vc)
        }
        
        var changeLocation = action(title: "Change location", leftSymbol: "location.fill")
        changeLocation.didTap { [unowned self] (_ : DSActionVM) in
            let vc = ChangeLocationViewController()
            self.push(vc)
        }
        
        var changeLanguage = action(title: "Change language", leftSymbol: "textformat.alt")
        changeLanguage.didTap { [unowned self] (_ : DSActionVM) in
            let vc = ChangeLanguageController()
            self.push(vc)
        }
        
        let section = [certificates, changeLocation, changeLanguage].list()
        section.subheadlineHeader("Settings")
        
        return section
    }
}

// MARK: - Authentification
extension ProfileViewController {
    
    /// Login with phone and password section
    /// - Returns: DSSection
    func getLoginAuthorizationSection() -> DSSection {
        
        // Email
        let email = DSTextFieldVM.email(placeholder: "Email")
        email.text = formEmailValue
        email.errorPlaceHolderText = "example@email.com"
        email.didUpdate = { textField in
            self.formEmailValue = textField.text
        }
        
        // Password
        let password = DSTextFieldVM.password(placeholder: "Password")
        password.text = formPasswordValue
        password.errorPlaceHolderText = "min 8 characters"
        password.didUpdate = { textField in
            self.formPasswordValue = textField.text
        }
        
        // Sign in button
        var button = DSButtonVM(title: "Sign In")
        button.didTap { [unowned self] (_: DSButtonVM) in
            
            // Comment this code to enable validation
            BookingManager.shared.authorized = true
            self.show(message: "Successful authorization", type: .success) {
                self.update()
            }
            
            // Uncomment this code to enable validation
            //            self.isCurrentFormValid { isValid in
            //                
            //                if isValid {
            //                    BookingManager.shared.authorized = true
            //                    self.show(message: "Successful authorization", type: .success) {
            //                        self.update()
            //                    }
            //                } else {
            //                    self.show(message: "Please fill all the required info", type: .error)
            //                }
            //            }
        }
        
        let description = "If you already have a username password, please enter bellow"
        let section = [email, password, button].list(grouped: true)
        section.subheadlineHeader(description)
        return section
    }
    
    /// Login with sms authorization
    /// - Returns: DSSection
    func getSmsAuthorizationSection() -> DSSection {
        
        // Phone number
        let phoneNumber = DSTextFieldVM.phone(placeholder: "Phone number")
        phoneNumber.text = formPhoneNumberValue
        phoneNumber.errorPlaceHolderText = "+373 xxx xxx xx"
        phoneNumber.didUpdate = { textField in
            self.formPhoneNumberValue = textField.text
        }
        
        // Password
        let password = DSTextFieldVM.password(placeholder: "Password")
        password.text = formPasswordValue
        password.errorPlaceHolderText = "min 8 characters"
        password.didUpdate = { textField in
            self.formPasswordValue = textField.text
        }
        
        // Get sms code
        var button = DSButtonVM(title: "Get SMS Code")
        button.didTap { [unowned self] (_: DSButtonVM) in
            
            self.isCurrentFormValid { isValid in
                if isValid {
                    BookingManager.shared.authorized = true
                    self.show(message: "Successful authorization", type: .success) {
                        self.update()
                    }
                } else {
                    self.show(message: "Please fill all the required info", type: .error)
                }
            }
        }
        
        let section = [phoneNumber, password, button].list(grouped: true)
        let description = "Enter the phone number to receive SMS with an access code to your dashboard"
        section.subheadlineHeader(description)
        return section
    }
    
    func clearAuthenticationInfo() {
        formEmailValue = nil
        formPasswordValue = nil
        formPhoneNumberValue = nil
    }
}

// MARK: - Helpers
extension ProfileViewController {
    
    /// Get action view model
    /// - Parameters:
    ///   - title: String
    ///   - subtitle: String?
    ///   - leftSymbol: leftSymbol
    /// - Returns: DSActionVM
    func action(title: String, subtitle: String? = nil, leftSymbol: String? = nil) -> DSActionVM {
        return DSActionVM(title: title, subtitle: subtitle, leftSFSymbol: leftSymbol)
    }
}
