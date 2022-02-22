//
//  SelectDayViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class SelectServicesViewController: DSViewController {
    
    //  Services group
    class ServiceGroup {
        
        var title: String
        var services: [Service]
        
        internal init(title: String, services: [Service]) {
            self.title = title
            self.services = services
        }
    }
    
    var isSelectedServicesExpanded: Bool = true
    var serviceGroups = [ServiceGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Services"
        setUpServicesGroups()
        update()
    }
    
    /// Update current content on the screen
    func update() {
        var sections = [DSSection]()
        setUpSelectedServices(&sections)
        setUpAllServicesGroups(&sections)
        show(content: sections)
        updateTotalView()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Total View
extension SelectServicesViewController {
    
    /// Update total view
    func updateTotalView() {
        
        if BookingManager.shared.services.isEmpty {
            hideBottomContent()
        } else {
            
            let servicesCount = BookingManager.shared.services.count
            
            let totalText = DSLabelVM(.title2, text: "Total")
            
            let forString = "for \(servicesCount) \(servicesCount.getCorrectForm(singular: "service", plural: "services")) "
            
            let priceText = DSTextComposer(alignment: .right)
            priceText.add(type: .subheadline, text: forString)
            priceText.add(price: BookingManager.shared.services.totalPrice(), size: .large, newLine: false)
            let priceVM = priceText.textViewModel()
            
            var button = DSButtonVM(title: "Continue")
            button.didTap { [unowned self] (button: DSButtonVM) in
                self.pop()
            }
            
            showBottom(content: [[totalText, priceVM].grid(), [button].list().interItemTopInset()])
        }
    }
}

// MARK: - Set up
extension SelectServicesViewController {
    
    /// Prepare service groups
    func setUpServicesGroups() {
        
        let spa = ServiceGroup(title: "Spa", services: BookingManager.getSpaServices())
        let barber = ServiceGroup(title: "Barber", services: BookingManager.getBarberServices())
        let proBarber = ServiceGroup(title: "Pro Barber", services: BookingManager.getProBarberServices())
        let promotions = ServiceGroup(title: "Promotions", services: BookingManager.getPromotionsServices())
        
        serviceGroups.append(contentsOf: [spa, barber, proBarber, promotions])
    }
    
    /// Set up selected services, and add sections
    /// - Parameter sections: [DSSection]
    func setUpSelectedServices(_ sections: inout [DSSection]) {
        
        let selectedServices = BookingManager.shared.services
        let services = isSelectedServicesExpanded ? selectedServices : []
        
        let section = getServicesSection(services: services , addAction: false)
        section.identifier = "Selected"
        section.headlineHeader("Selected")
        sections.append(section)
    }
    
    /// Set up all services groups
    /// - Parameter sections: [DSSection]
    func setUpAllServicesGroups(_ sections: inout [DSSection]) {
        
        for group in serviceGroups {
            
            let services = group.services.filter(BookingManager.shared.services)
            let section = getServicesSection(services: services, addAction: true)
            section.headlineHeader(group.title)
            section.identifier = group.title
            sections.append(section)
        }
    }
}

// MARK: - Service section
extension SelectServicesViewController {
    
    /// Map services in to DSSection
    /// - Parameters:
    ///   - services: Services to map
    ///   - addAction: if `addAction` is true then we will have `add` action on the right button else `remove`
    /// - Returns: DSSection
    func getServicesSection(services: [Service], addAction: Bool) -> DSSection {
        
        let services = services.map { (service) -> DSViewModel in
            return getServiceViewModel(for: service, addAction: addAction)
        }
        
        return services.list()
    }
    
    /// Service view model for service
    /// - Parameters:
    ///   - service: Service
    ///   - addAction: Bool
    /// - Returns: DSViewModel
    func getServiceViewModel(for service: Service, addAction: Bool) -> DSViewModel {
        
        var model = service.viewModel()
        
        let sfSymbolName = (addAction ? "plus.circle.fill" : "minus.circle.fill")
        
        // Handle did tap on right button, to add or remove a service
        model.rightButton(sfSymbolName: sfSymbolName, style: .custom(size: 18, weight: .medium)) { [unowned self] in
            
            if addAction {
                // Add new service to selected services
                BookingManager.shared.services.append(service)
            } else {
                // Remove service from selected services
                BookingManager.shared.services.removeAll { (a) -> Bool in
                    return a.id == service.id
                }
            }
            
            // Call update to reload the UI
            self.update()
        }
        
        // Pass service as companion object to viewModel
        model.object = service as AnyObject
        
        return model
    }
}
