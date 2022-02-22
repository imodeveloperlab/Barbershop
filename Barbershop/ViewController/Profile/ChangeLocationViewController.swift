//
//  ChangeLocationViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class ChangeLocationViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    var defaultLocation = "325 Broadway"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shop location"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: getShopsSection())
    }
}

extension ChangeLocationViewController {
    
    /// Shops
    /// - Returns: DSSection
    func getShopsSection() -> DSSection {
        
        var shops = faker.addresses.map { (address) -> DSViewModel in
            
            // Shop info
            let composer = DSTextComposer()
            composer.add(type: .headline, text: address.title)
            composer.add(type: .subheadline, text: address.address)
           
            // Action
            let isSelected = address.title == defaultLocation
            var action = composer.checkboxActionViewModel(selected: isSelected)
            action.leftIcon(sfSymbolName: "house.fill")
            
            // Set address as companion object
            action.object = address as AnyObject
            
            return action
        }
        
        // Handle did tap on shop
        shops = shops.didTap({ (shop: DSActionVM) in
            
            guard let address = shop.object as? DSAddress else {
                return
            }
            
            self.defaultLocation = address.title
            self.update()
            self.show(message: "Your default shop was successfully updated", type: .success, timeOut: 0.5)
        })
        
        return shops.list().subheadlineHeader("Select a shop as your default shop")
    }
}
