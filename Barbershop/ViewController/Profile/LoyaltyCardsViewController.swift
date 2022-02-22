//
//  ProfileUpdatePasswordViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class LoyaltyCardsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Loyalty Cards"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        show(content: getCardsSection())
    }
}

// MARK: - Cards section
extension LoyaltyCardsViewController {
    
    func getCardsSection() -> DSSection {
        
        let composer = DSTextComposer()
        composer.add(type: .headlineWithSize(30), text: "Bonus Card")
        composer.add(type: .subheadline, text: "0006 5236 1689 9521")
        composer.add(type: .body, text: "Discount: 10%, Points 0, Cash Back 5%")
        
        var bonusCard = DSCardVM(composer: composer, textPosition: .center)
        bonusCard.decorationImage = DSSFSymbolConfig.buttonIcon("percent")
        
        let composer2 = DSTextComposer()
        composer2.add(type: .headlineWithSize(30), text: "Gift Card")
        composer2.add(type: .subheadline, text: "0006 4444 1689 5234")
        composer2.add(type: .body, text: "Discount: 80%, Points 10, Cash Back 15%")
        
        var giftCard = DSCardVM(composer: composer, textPosition: .center)
        giftCard.decorationImage = DSSFSymbolConfig.buttonIcon("giftcard")
        
        let section = DSListSection(viewModels: [bonusCard, giftCard])
        section.insets.equalTopBottom(appearance.margins)
        return section
    }
    
}
