//
//  NotificationDetailsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class NotificationDetailsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [notificationSection()])
    }
    
    // Get notification section
    func notificationSection() -> DSSection {
        
        let title = DSLabelVM(.title1, text: faker.sentence)
        
        let string = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries"
        
        var text1 = DSActiveTextVM(.body, text: string)
        text1.links = ["printing and typesetting":"https://www.lipsum.com",
                       "specimen book": "https://www.lipsum.com"]
        
        let text2 = DSLabelVM(.body, text: faker.text)
        let text3 = DSLabelVM(.body, text: faker.text)
        
        // Date
        let dateText = DSTextComposer()
        dateText.add(type: .headline, text: Date().stringFormatted(), icon: UIImage(systemName: "calendar"))
        let date = DSActionVM(composer: dateText)
        
        let section = DSListSection(viewModels: [title, date, text1, text2, text3])
        return section
    }
}

