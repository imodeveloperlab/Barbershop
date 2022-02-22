//
//  MyBookingsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit

class MyBookingsViewController: DSViewController {
    
    var currentSectionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Bookings"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        var sections = [DSSection]()
        
        sections.append(getSwitchSectionsSection())
        
        if currentSectionIndex == 0 {
            sections.append(getUpcomingBookingsSection())
        } else if currentSectionIndex == 1 {
            sections.append(getPastBookingsSection())
        } else {
            sections.append(getSpecialBookingsSection())
        }

        self.show(content: sections)
    }
}

// MARK: - Switch sections
extension MyBookingsViewController {
    
    func getSwitchSectionsSection() -> DSSection {
        
        let segment = DSSegmentVM(segments: ["Upcoming", "Past", "Special"])
        
        segment.didTapOnSegment = { segment in
            self.currentSectionIndex = segment.index
            self.update()
        }
        
        let section = DSListSection(viewModels: [segment])
        return section
    }
}

// MARK: - Sections
extension MyBookingsViewController {
 
    /// Upcoming bookings
    /// - Returns: DSSection
    func getUpcomingBookingsSection() -> DSSection {
        
        let bookings = BookingManager.getSpaServices().map { (service) -> DSViewModel in
            return bookingViewModel(service: service)
        }

        return bookings.list()
    }
    
    /// Past bookings
    /// - Returns: DSSection
    func getPastBookingsSection() -> DSSection {
        
        let bookings = BookingManager.getBarberServices().map { (service) -> DSViewModel in
            return bookingViewModel(service: service)
        }
        
        return bookings.list()
    }
    
    /// Special bookings
    /// - Returns: DSSection
    func getSpecialBookingsSection() -> DSSection {
        
         return getPlaceholderSection(image: UIImage(systemName: "wand.and.stars"),
                                      text: "You don't have any special\nbookings at the moment")
    }
}

// MARK: - Helpers
extension MyBookingsViewController {
    
    /// Booking view model
    /// - Parameter service: Service
    /// - Returns: DSViewModel
    func bookingViewModel(service: Service) -> DSViewModel {
        
        let text = DSTextComposer()
        text.add(type: .headline, text: service.title)
        text.add(type: .subheadline, text: Date().stringFormatted(), icon: UIImage(systemName: "calendar"))
        text.add(price: DSPrice(amount: service.amount.stringAmount(), currency: service.currency))
        
        var model = DSActionVM(composer: text)
        model.style.displayStyle = .grouped(inSection: false)
        model.object = service as AnyObject
        
        model.didTap { [unowned self] (model: DSActionVM) in
            self.openBookingDetails(service: service)
        }
        
        return model
    }
    
    /// Open booking details
    /// - Parameter service: Service
    func openBookingDetails(service: Service) {
        let vc = BookingDetailsViewController(service: service)
        self.present(vc: vc, presentationStyle: .formSheet)
    }
}
