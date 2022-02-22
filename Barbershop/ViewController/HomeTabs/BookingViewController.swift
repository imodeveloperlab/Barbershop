//
//  BookingViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery
import MapKit

class BookingViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Booking"
        update()
    }
    
    @objc func closeDemo() {
        self.dismiss()
    }
    
    func update() {
        
        // Map all addresses in to DSViewModel / DSMapVM
        var locations = faker.addresses.map { (address) -> DSViewModel in
            address.viewModel()
        }
        
        // Handle did tap on location
        locations = locations.didTap({ (shop: DSMapVM) in
            
            guard let address = shop.object as? DSAddress else {
                return
            }
            
            // Tap on location will open BookViewController
            self.push(BookViewController(address: address))
        })
        
        let listSection = locations.list()
        listSection.subheadlineHeader("Select a shop where you want to make a booking")
        
        // Show content on this view controller
        show(content: listSection)
    }
}
