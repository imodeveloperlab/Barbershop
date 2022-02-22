//
//  SelectSpecialistViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class SelectSpecialistViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select specialist"
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBarShadow()
    }
    
    /// Update current content on the screen
    func update() {
        show(content: getSpecialistSections())
    }
}

// MARK: - Sections
extension SelectSpecialistViewController {
    
    /// Select specialists
    /// - Returns: DSSection
    func getSpecialistSections() -> [DSSection] {
        
        var sections = [DSSection]()
        
        // Map and group all barbers in specific sections
        let specialists = faker.barbers.enumerated().map { (index, person) -> [DSSection] in
            
            // Specialist
            let specialist = getSpecialistViewModel(for: person)
            
            let text = DSLabelVM(.caption2, text: "Nearest time for appointment")
            let specialistSection = [specialist, text].list()
            
            // Available times section
            let timeSection = getAvailableTimes(for: person)
            
            return [specialistSection, timeSection]
            
        }.flatMap({ $0 })
        
        sections.append(contentsOf: specialists)
        return sections
    }
    
    /// Get specialist section
    /// - Parameter person: Person
    /// - Returns: PersonVM
    func getSpecialistViewModel(for person: DSPerson) -> DSActionVM {
        
        var specialist = person.viewModel(.default)
        
        // Handle did tap on specialist
        specialist.didTap { [unowned self] (action: DSActionVM) in
            
            guard let person = action.object as? DSPerson else {
                return
            }
            
            BookingManager.shared.selectedSpecialist = person
            self.pop()
        }
        
        // Handle did tap on right button
        specialist.rightButton(sfSymbolName: "info.circle", style: .custom(size: 16, weight: .medium)) { [unowned self] in
            let specialistDetails = SpecialistDetailsViewController(person: person)
            self.push(specialistDetails)
        }
        
        return specialist
    }
    
    /// Generate available times for person
    /// - Parameter person: Person
    /// - Returns: DSSection
    func getAvailableTimes(for person: DSPerson) -> DSSection {
        
        var timesModels = [DSViewModel]()
        
        // Random generate available times
        for i in 1...Int.random(in: 2...5) {
            
            // Style
            let font = appearance.fonts.headline.withSize(15)
            let color = appearance.secondaryView.text.title1
            
            // Text
            var text = DSLabelVM(.custom(font: font, color: color), text: "\(12 + i): 00", alignment: .center)
            text.height = .absolute(40)
            text.style.displayStyle = .grouped(inSection: false)
            text.object = person as AnyObject
            timesModels.append(text)
        }
        
        // Handle did tap in time
        timesModels = timesModels.didTap { [unowned self] (time: DSLabelVM) in
            
            guard let person = time.object as? DSPerson else {
                return
            }
            
            // Set specialist and time to booking manager
            BookingManager.shared.selectedSpecialist = person
            BookingManager.shared.dateAndTime = Date()
            self.pop()
        }
        
        let section = timesModels.grid(columns: 4)
        section.interItemTopInset()
        return section
    }
}
