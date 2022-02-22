//
//  DSAddress.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 25.01.2021.
//

import UIKit
import DSKit
import DSKitFakery

extension DSAddress {
    
    /// Map DSAddress to DSMapVM
    /// - Returns: DSMapVM
    func viewModel() -> DSMapVM {
        
        let text = DSTextComposer()
        text.add(type: .headline, text: "Barber Shop \(title)")
        text.add(type: .subheadline, text: address + " · \(Int.random(in: 3...7))km away", icon: UIImage(systemName: "house.fill"))
        
        var shop = DSMapVM(text: text, coordinate: coordinate)
        shop.style.displayStyle = .grouped(inSection: false)
        shop.object = self as AnyObject
        
        return shop
    }
}
