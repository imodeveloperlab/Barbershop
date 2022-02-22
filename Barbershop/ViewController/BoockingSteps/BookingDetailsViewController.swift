//
//  BookingDetailsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class BookingDetailsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    let service: Service
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(content: [detailsSection()])
    }
    
    func detailsSection() -> DSSection {
        
        // Title
        let title = DSLabelVM(.title1, text: service.title)
        
        // Description
        let description = DSLabelVM(.subheadline, text: faker.text)
        
        // Shop
        let shop = faker.address.viewModel()

        // Specialist
        var specialist = DSFaker().person.viewModel()
        specialist.rightNone()
        specialist.style.displayStyle = .grouped(inSection: false)
        
        // Date
        let dateText = DSTextComposer()
        dateText.add(type: .subheadline, text: Date().stringFormatted(), icon: UIImage(systemName: "calendar"))
        let date = DSActionVM(composer: dateText)
        
        // Price
        let priceText = DSTextComposer()
        priceText.add(price: DSPrice(amount: "10.00", currency: "$"), size: .extraLarge)
        let price = DSActionVM(composer: priceText)
        
        return [title, description, specialist, shop, date, price].list()
    }
    
    init(service: Service) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
