//
//  SpecialistDetailsFeedbackViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class SpecialistDetailsFeedbackViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    let person: DSPerson
    var rating = 5
    var feedback: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarShadow()
        update()
    }
    
    /// Update current content on the screen
    func update() {
        
        let button = DSButtonVM(title: "Submit") { _ in
            self.show(message: "Thank you for your feedback", type: .success) {
                self.dismiss()
            }
        }
        
        let cancel = DSButtonVM(title: "Cancel", type: .link) { _ in
            self.dismiss()
        }
        
        show(content: specialistDetailsSection(),
             textViewSection(),
             ratingSection(),
             [button, cancel].list())
    }
    
    func specialistDetailsSection() -> DSSection {
        
        // Title
        let title = DSLabelVM(.title1, text: "Feedback")
        
        // Specialist
        var specialist = person.viewModel()
        specialist.rightNone()
        specialist.style.displayStyle = .grouped(inSection: false)
        
        return [title, specialist].list()
    }
    
    /// Text view section
    /// - Returns: DSSection
    func textViewSection() -> DSSection {
        
        let textView = DSTextViewVM(text: feedback)
        
        // Handle this did update
        textView.didUpdate = { vm in
            self.feedback = vm.text
        }
        textView.height = .absolute(100)
        
        return [textView].list().subheadlineHeader("Write your feedback")
    }
    
    /// Rating section
    /// - Returns: DSSection
    func ratingSection() -> DSSection {
        
        var ratingViewModels = [DSViewModel]()
        
        for r in 1...5 {
            var model = starViewModel(fill: r <= rating)
            model.object = r as AnyObject
            ratingViewModels.append(model)
        }
        
        ratingViewModels = ratingViewModels.didTap({ (action :DSActionVM) in
            
            guard let newRating = action.object as? Int else {
                return
            }
            
            self.rating = newRating
            self.update()
        })
        
        return ratingViewModels.gallery().subheadlineHeader("Rate the specialist")
    }
    
    /// Star view model
    /// - Parameter fill: Is star filled or not
    /// - Returns: Bool
    func starViewModel(fill: Bool) -> DSActionVM {
        
        let brandColor = UIColor.systemYellow
        let composer = DSTextComposer()
        
        if fill {
            composer.add(sfSymbol: "star.fill", style: .medium, tint: .custom(brandColor))
        } else {
            composer.add(sfSymbol: "star", style: .medium, tint: .subheadline)
        }
        
        var action = composer.actionViewModel()
        action.style.displayStyle = .default
        action.width = .absolute(30)
        action.height = .absolute(30)
        return action
    }
    
    /// Init view controller with person
    /// - Parameter person: DSPerson
    init(person: DSPerson) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
