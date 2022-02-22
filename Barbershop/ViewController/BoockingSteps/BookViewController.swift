//
//  BookViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery
import DSKitCalendar

class BookViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    let address: DSAddress
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Booking"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        let sections = [getSelectedShopSection(),
                        getSpecialistSection(),
                        getServiceSection(),
                        getDateAndTimeSection(),
                        getBookActionSection()]
        
        show(content: sections, scrollToBottom: true)
    }
    
    init(address: DSAddress) {
        self.address = address
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Shops
extension BookViewController {
    
    /// Shop
    /// - Returns: DSSection
    func getSelectedShopSection() -> DSSection {
        
        let header = self.header(title: "Shop")
        var shop = address.viewModel()
        shop.height = 200
        
        let viewModels: [DSViewModel] = [header, shop]
        
        // Transform and return `viewModels` as list section
        return viewModels.list()
    }
}

// MARK: - Services
extension BookViewController {
    
    /// Select service
    /// - Returns: DSSection
    func getServiceSection() -> DSSection {
        
        if !BookingManager.shared.services.isEmpty {
            
            // If user already selected all services he need, we will show them
            let serviceSection = getServicesSection(services: BookingManager.shared.services)
            return serviceSection
            
        } else {
            
            // Else we will show select new service option
            var services = DSActionVM(title: "Services",
                                      subtitle: "Select service",
                                      leftSFSymbol: "scissors.badge.ellipsis")
            
            services.didTap { [unowned self] (action: DSActionVM) in
                let vc = SelectServicesViewController()
                self.push(vc)
            }
            
            // Transform and return `services` as list section
            return services.list()
        }
    }
    
    /// Map services in to DSSection
    /// - Parameters:
    ///   - services: Services to map
    ///   - addAction: if `addAction` is true then we will have `add` action on the right button else `remove`
    /// - Returns: DSSection
    func getServicesSection(services: [Service]) -> DSSection {
        
        var viewModels = [DSViewModel]()
        
        // Header view
        let header = self.header(title: "Service")
        viewModels.append(header)
        
        // Services view models
        let serviceViewModels = services.map { (service) -> DSViewModel in
            
            var serviceViewModel = service.viewModel()
            
            // Set right button with an action handler, if user will press on button
            // this closure will be called
            serviceViewModel.rightButton(sfSymbolName: "minus.circle.fill", style: .custom(size: 18, weight: .medium)) { [unowned self] in
                
                // Remove service from selected services
                BookingManager.shared.services.removeAll { (a) -> Bool in
                    return a.id == service.id
                }
                
                // Call update to reload the UI
                self.update()
            }
            
            return serviceViewModel
        }
        
        viewModels.append(contentsOf: serviceViewModels)
        
        // Edit selected services action
        var edit = DSActionVM(title: "Manage selected services")
        edit.didTap { [unowned self] (action: DSActionVM) in
            let vc = SelectServicesViewController()
            self.push(vc)
        }
        
        viewModels.append(edit)
        
        // Transform and return `viewModels` as list section
        return viewModels.list()
    }
}

// MARK: - Specialists
extension BookViewController {
    
    /// Select selectedSpecialist section
    /// - Returns: DSSection
    func getSpecialistSection() -> DSSection {
        
        var viewModels = [DSViewModel]()
        
        if let person = BookingManager.shared.selectedSpecialist {
            
            // If we have selected specialist, show selected specialist
            let title = self.header(title: "Barber")
            let specialist = getSpecialistViewModel(person: person)
            viewModels.append(contentsOf: [title, specialist])
            
        } else {
            
            // If we don't have any specialist selected, show select specialist
            var specialist = DSActionVM(title: "Barber",
                                        subtitle: "Select specialist",
                                        leftSFSymbol: "person.fill")
            
            specialist.didTap { [unowned self] (action: DSActionVM) in
                
                // Select specialist
                let vc = SelectSpecialistViewController()
                self.push(vc)
            }
            
            viewModels.append(specialist)
        }
        
        // Transform and return `viewModels` as list section
        return viewModels.list()
    }
    
    /// Get specialist section
    /// - Parameter person: Person
    /// - Returns: PersonVM
    func getSpecialistViewModel(person: DSPerson) -> DSViewModel {
        
        var specialist = person.viewModel()
        
        specialist.rightButton(sfSymbolName: "pencil.circle.fill", style: .custom(size: 18, weight: .medium)) { [unowned self] in
            
            // Open change specialist
            let vc = SelectSpecialistViewController()
            self.push(vc)
        }
        
        specialist.leftRoundImage(url: person.image)
        
        // Open change specialist
        specialist.didTap { [unowned self] (specialist: DSActionVM) in
            let vc = SelectSpecialistViewController()
            self.push(vc)
        }
        
        return specialist
    }
}

// MARK: - Date & Time
extension BookViewController {
    
    /// Date and time
    /// - Returns: DSSection
    func getDateAndTimeSection() -> DSSection {
        
        var viewModels = [DSViewModel]()
        
        if !BookingManager.shared.services.isEmpty || BookingManager.shared.dateAndTime != nil {
            let title = self.header(title: "Date & Time")
            viewModels.append(title)
        }
        
        if let dateAndTime = BookingManager.shared.dateAndTime {
            
            // If we have date & time we will show selected date & time with option to change it
            var date = DSActionVM(title: dateAndTime.stringFormatted(), leftSFSymbol: "calendar")
            date.rightButton(sfSymbolName: "pencil.circle.fill", style: .custom(size: 18, weight: .medium), action: { [unowned self] in
                self.openSelectDate()
            })
            
            // Open select date and time
            date.didTap { [unowned self] (action: DSActionVM) in
                self.openSelectDate()
            }
            
            viewModels.append(date)
            
        } else {
            
            // Else we will show select date & time action
            var dateAndTime = DSActionVM(title: "Date & Time",
                                         subtitle: "Select date and time",
                                         leftSFSymbol: "calendar")
            
            // Open select date and time
            dateAndTime.didTap { [unowned self] (action: DSActionVM) in
                self.openSelectDate()
            }
            
            viewModels.append(dateAndTime)
        }
        
        // Transform and return `viewModels` as list section
        return viewModels.list()
    }
    
    /// Open select date & time
    func openSelectDate() {
        
        let startDate = Date()
        guard let endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDate) else {
            return
        }
        
        // Instantiate and push (show) select day controller
        let selectDay = DSCalendarViewController(startDate: startDate, endDate: endDate, excludeDates: [Date]())
        self.push(selectDay)
        
        // Handle did select date in `selectDay` view controller
        selectDay.didSelectDate = { date in
            
            // Instantiate and push (show) select hour view controller
            let selectHour = SelectHourViewController(date: date)
            self.push(selectHour)
            
            // Handle did select hour in `selectHour` view controller
            selectHour.didSelectTime = { date in
                
                // Set selected date in BookingManager and push back to this view controller
                BookingManager.shared.dateAndTime = date
                self.pop(to: self)
            }
        }
    }
}

// MARK: - Book Action
extension BookViewController {
    
    /// Book section
    /// - Returns: DSSection
    func getBookActionSection() -> DSSection {
        
        var viewModels = [DSViewModel]()
        
        if BookingManager.shared.isValidBooking()  {
            
            var button = DSButtonVM(title: "Complete Booking", icon: UIImage(systemName: "bookmark.fill"))
            
            // Handle did tap on button
            button.didTap { [unowned self] (_ : DSButtonVM) in
                self.completeBooking()
            }
            
            viewModels.append(button)
        }
        
        // Transform and return `viewModels` as list section
        // if we will return a empty section, nothing will be displayed
        return viewModels.list()
    }
    
    /// Complete booking
    func completeBooking() {
        show(message: "Booking was successfully completed", type: .success, timeOut: 1) {
            self.popToRoot()
        }
    }
}

// MARK: - Helpers
extension BookViewController {
    
    /// Get header view with title
    /// - Parameter title: title text
    /// - Returns: DSViewModel
    func header(title: String) -> DSViewModel {
        return DSLabelVM(.subheadline, text: title)
    }
}
