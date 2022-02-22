//
//  ViewController.swift
//  Barbershop
//
//  Created by Ivan Borinschi on 10.02.2022.
//

import UIKit
import DSKit

open class ViewController: DSTabBarViewController {
    
    let booking = BookingViewController()
    let profile = ProfileViewController()
    let aboutUs = AboutUsViewController()
    let myBookings = MyBookingsViewController()
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        let config = DSSFSymbolConfig.symbolConfig(style: .custom(size: 20, weight: .semibold))
        
        // Booking tab
        booking.tabBarItem.title = "Booking"
        booking.tabBarItem.image = UIImage(systemName: "calendar.badge.plus", withConfiguration: config)
        
        // Profile tab
        profile.tabBarItem.title = "Profile"
        profile.tabBarItem.image = UIImage(systemName: "person.crop.circle", withConfiguration: config)
        
        // About us
        aboutUs.tabBarItem.title = "About Us"
        aboutUs.tabBarItem.image = UIImage(systemName: "scissors", withConfiguration: config)
        
        // My bookings
        myBookings.tabBarItem.title = "My Bookings"
        myBookings.tabBarItem.image = UIImage(systemName: "bookmark.fill", withConfiguration: config)
        
        // Set tabbar view controllers
        setViewControllers([DSNavigationViewController(rootViewController: booking),
                            DSNavigationViewController(rootViewController: profile),
                            DSNavigationViewController(rootViewController: aboutUs),
                            DSNavigationViewController(rootViewController: myBookings)], animated: true)
    }
}
