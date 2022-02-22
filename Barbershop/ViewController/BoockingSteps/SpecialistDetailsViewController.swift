//
//  SpecialistDetailsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class SpecialistDetailsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    let person: DSPerson
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        // Specialest info
        show(content: [getSpecialistSection(), getFeedbackSection()])
        
        // Leave feedback action
        let button = DSButtonVM(title: "Leave feedback", icon: UIImage(systemName: "message.fill")) { _ in
            self.present(vc: SpecialistDetailsFeedbackViewController(person: self.person), presentationStyle: .fullScreen)
        }
        showBottom(content: button)
    }
    
    init(person: DSPerson) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Sections
extension SpecialistDetailsViewController {
    
    /// Specialist detail section
    /// - Returns: DSSection
    func getSpecialistSection() -> DSSection {
        
        // Profile picture
        let picture = DSImageVM(imageUrl: person.image, height: .absolute(120), displayStyle: .circle)
        
        // Profile description
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .title1, text: person.name)
        composer.add(type: .body, text: person.description)
        return [picture, composer.textViewModel()].list()
    }
    
    /// Get specialist description section
    /// - Returns: DSSection
    func getSpecialistDescriptionSection() -> DSSection {
        
        let text = DSTextComposer()
        text.add(type: .body, text: faker.text, icon: UIImage(systemName: "checkmark.shield.fill"))
        text.add(type: .subheadline, text: faker.text)
        let action = DSActionVM(composer: text)
        return [action].list()
    }
    
    /// Feedback section
    /// - Returns: DSSection
    func getFeedbackSection() -> DSSection {
        
        let models = [0,1,2,4,5].map { (index) -> DSViewModel in
            
            let composer = DSTextComposer()
            composer.add(type: .headline, text: faker.name)
            
            let subheadlineFont = DSAppearance.shared.main.fonts.subheadline
            let bodyColor = DSAppearance.shared.main.secondaryView.text.body
            
            // Date
            composer.add(type: .subheadline,
                         text: Date().stringFormatted(),
                         icon: UIImage(systemName: "calendar"))
            
            // Rating
            composer.add(rating: Int.random(in: 2...5),
                         maximumValue: 5,
                         positiveSymbol: "star.fill",
                         negativeSymbol: "star",
                         style: .custom(size: 15, weight: .medium),
                         tint: .custom(UIColor.systemYellow))
            
            // Feedback text
            composer.add(type: .custom(font: subheadlineFont, color: bodyColor),
                         text: faker.text)
            
            // Transform composer in action view model
            return composer.actionViewModel()
        }
        
        // Return all models as list section
        return models.list()
    }
}
