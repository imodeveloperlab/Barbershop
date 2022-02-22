//
//  ChangeLanguageController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit

class ChangeLanguageController: DSViewController {
    
    var defaultLanguage = "English"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Language"
        update()
    }
    
    /// Update current content on the screen
    func update()  {
        
        // Language view models
        var languages = ["English", "Russian", "Italian", "Spanish"].map { (language) -> DSViewModel in
            
            let text = DSTextComposer()
            text.add(type: .headline, text: language)
            let isSelected = language == defaultLanguage
            var action = text.checkboxActionViewModel(selected: isSelected)
            action.object = language as AnyObject
            return action
        }
        
        // Handle did tap on language
        languages = languages.didTap({ (language: DSActionVM) in
            
            guard let language = language.object as? String else {
                return
            }
            
            self.defaultLanguage = language
            self.update()
        })
        
        
        let description = "Select a language as your default language"
        
        // Show languages with header
        show(content: languages.list().subheadlineHeader(description))
    }
}
