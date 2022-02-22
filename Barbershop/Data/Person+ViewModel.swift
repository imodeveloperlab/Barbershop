//
//  PersonExtension.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 19.01.2021.
//

import UIKit
import DSKit
import DSKitFakery

extension DSPerson {
    
    /// Map DSPerson to DSActionVM
    /// - Parameter displayStyle: DSViewModelDisplayStyle
    /// - Returns: DSActionVM
    func viewModel(_ displayStyle: DSViewModelDisplayStyle = .grouped(inSection: false)) -> DSActionVM {
        
        var specialist = DSActionVM(title: name, subtitle: description)
        specialist.leftRoundImage(url: image)
        specialist.style.displayStyle = displayStyle
        specialist.object = self as AnyObject
        return specialist
    }
}
