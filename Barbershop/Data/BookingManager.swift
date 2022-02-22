//
//  BookingManager.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import Foundation
import DSKit
import DSKitFakery

class BookingManager {
    
    // Simulate user authorization
    public var authorized: Bool = false
    
    // Selected specialist for booking
    public var selectedSpecialist: DSPerson?
    
    // Selected services
    public var services = [Service]()
    
    // Selected date and time
    public var dateAndTime: Date?
    
    // Is current booking valid
    func isValidBooking() -> Bool {
        return selectedSpecialist != nil && !services.isEmpty && dateAndTime != nil
    }
    
    // Shared instance
    static let shared = BookingManager()
    
    public init() {}
    
    func reset() {
        selectedSpecialist = nil
        dateAndTime = nil
        services.removeAll()
    }
}

extension BookingManager {
    
    static func getPromotionsServices() -> [Service] {
        
        [
            Service(id: 1, title: "Happy Birth Day", duration: "1h", amount: 1000, regularAmount: 2000, currency: "$", picture: URL.birthdayUrl()),
            Service(id: 2, title: "First Visit -10%", duration: "1h", amount: 1000, regularAmount: 2000,  currency: "$"),
            Service(id: 3, title: "Father and Son -15%", duration: "1h", amount: 1000, regularAmount: 2000,  currency: "$"),
            Service(id: 4, title: "Complex (Monday and Tuesday 10:00 - 13:00)", duration: "1h", amount: 1000,regularAmount: 2000,  currency: "$"),
            Service(id: 5, title: "Haircut (Monday and Tuesday 10:00 - 13:00)", duration: "1h", amount: 1000, regularAmount: 2000, currency: "$")
        ]
    }
    
    static func getProBarberServices() -> [Service] {
        
        [
            Service(id: 6, title: "Haircut Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 7, title: "Head Shaving Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 8, title: "Children Haircut (6 - 10 years) Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 9, title: "Beard Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 10, title: "Beard Tinting Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 11, title: "Beard Shaving Pro Barber", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 12, title: "Beard Arranging Pro Barber", duration: "1h", amount: 1000, currency: "$")
        ]
    }
    
    static func getBarberServices() -> [Service] {
        
        [
            Service(id: 13, title: "Haircut", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 14, title: "Head Shaving", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 15, title: "Children Haircut (6 - 10 years)", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 16, title: "Beard", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 17, title: "Beard Tinting", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 18, title: "Beard Shaving", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 19, title: "Beard Arranging", duration: "1h", amount: 1000, currency: "$")
        ]
    }
    
    static func getBarberService() -> Service {
        return BookingManager.getBarberServices()[0]
    }
    
    static func getSpaServices() -> [Service] {
        
        [
            Service(id: 20, title: "Additional Care", duration: "1h", amount: 1000, currency: "$"),
            Service(id: 21, title: "Eyebrow Correction", duration: "1h", amount: 1000, currency: "$")
        ]
    }
}

