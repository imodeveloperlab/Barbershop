//
//  NotificationsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class NotificationsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [getNotificationsSection()])
    }
}

// MARK: - Notifications
extension NotificationsViewController {
    
    /// Notifications section
    /// - Returns: DSSection
    func getNotificationsSection() -> DSSection {
        
        let notifications = [0,1,2,3,4,5].map { index -> DSViewModel in
            
            let text = DSTextComposer()
            text.add(type: .headline, text: faker.sentence)
            text.add(type: .subheadline, text: Date().stringFormatted(), icon: UIImage(systemName: "calendar"))
            text.add(type: .caption1, text: faker.text)
            
            var notification = DSActionVM(composer: text)
            notification.leftIcon(sfSymbolName: "info.circle.fill")
            notification.leftViewPosition = .top
            
            notification.didTap { [unowned self] (_ :DSActionVM) in
                self.showNotificationDetails()
            }
            
            return notification
        }
        
        return notifications.list()
    }

    // Open notification details view controller
    func showNotificationDetails() {
        let vc = NotificationDetailsViewController()
        self.present(vc: vc, presentationStyle: .formSheet)
    }
}
