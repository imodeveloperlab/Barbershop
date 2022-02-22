//
//  Service.swift
//  Demo Barbershop
//
//  Created by Borinschi Ivan on 19.02.2021.
//

import DSKit
import DSKit
import DSKitFakery
import UIKit

struct Service {
    
    var id: Int
    var title: String
    var duration: String
    var amount: Int
    var regularAmount: Int?
    var currency: String
    var picture: URL?
    
    var price: DSPrice {
        
        var price = DSPrice(amount: amount.stringAmount(), regularAmount: regularAmount?.stringAmount(), currency: currency)
        
        if regularAmount != nil {
            price.discountBadge = "50% Off"
        }
        
        return price
    }
}

extension Service {
    
    func viewModel() -> DSActionVM {
        
        let text = DSTextComposer()
        text.add(type: .headline, text: title)
        text.add(type: .subheadline, text: "Duration: ", icon: UIImage(systemName: "timer"))
        text.add(type: .footnote, text: duration, newLine: false)
        text.add(price: price)
        
        var action = DSActionVM(composer: text)
        
        if let picture = picture {
            action.height = .absolute(200)
            action.topImage(url: picture, height: .equalTo(200), contentMode: .scaleAspectFill)
        }
        
        return action
    }
}

extension Array where Element == Service {
    
    func filter(_ exclude: [Service]) -> [Service] {
        return self.filter { (a) -> Bool in
            return !exclude.map({ $0.id }).contains(a.id)
        }
    }
    
    func totalPrice() -> DSPrice {
        
        let total: Int = self.reduce(0) { (total, service) -> Int in
            return total + service.amount
        }
        
        return DSPrice(amount: total.stringAmount(), currency: self.first?.currency ?? "$")
    }
}
