//
//  RetroAppearance.swift
//  DSKit
//
//  Created by Borinschi Ivan on 30.11.2020.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

public final class RetroAppearance: DSDesignable {
    
    // Appearance title
    public var title: String
    
    // Brand color
    public var brandColor: UIColor
    
    // Primary view colors
    public var primaryView: DSDesignableViewColors
    
    // Secondary view colors
    public var secondaryView: DSDesignableViewColors
    
    // General view margins
    public var margins: CGFloat = 15
    
    // Margins for grouped content
    public var groupMargins: CGFloat = 10
    
    // Inter items spacing
    public var interItemSpacing: CGFloat = 7
    
    // Tab bar colors
    public var tabBar: DSDesignableTabbarColor
    
    // Navigation bar colors
    public var navigationBar: DSDesignableNavigationBarColor
    
    // Currency colors
    public var price: DSDesignablePriceColor
    
    // Fonts
    public var fonts = DSDesignableFonts()
    
    // Prefer large titles
    public var prefersLargeTitles: Bool = true
    
    // Default buttons heights
    public var buttonsHeight: CGFloat = 45
    
    // Status bar styles
    public var statusBarStyleForDarkUserInterfaceStyle: UIStatusBarStyle = .lightContent
    public var statusBarStyleForLightUserInterfaceStyle: UIStatusBarStyle = .darkContent
    
    /// Init system appearance with brand color, or primary color of your app
    /// - Parameter primaryBrandColor: UIColor
    public init(brandColor: UIColor? = nil, title: String = "Retro") {
        
        self.title = title
        self.brandColor = brandColor ?? DSColor.color(light: 0xFF8F00, dark: 0xFF8F00)
        
        // MARK: - Secondary view
        
        let text = DSDesignableTextColor(largeTitle: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         title1: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         title2: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         title3: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         headline: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         subheadline: DSColor.color(light: 0x4E4A57, dark: 0x9699A8),
                                         body: DSColor.color(light: 0x2B2834, dark: 0xE8E7E6),
                                         callout: DSColor.color(light: 0x4E4A57, dark: 0x9699A8),
                                         caption1: DSColor.color(light: 0x4E4A57, dark: 0x9699A8),
                                         caption2: DSColor.color(light: 0x4E4A57, dark: 0x9699A8),
                                         footnote: DSColor.color(light: 0x4E4A57, dark: 0x9699A8))
        
        let primaryViewTextField = DSDesignableTextFieldColor(border: DSColor.color(light: 0xF4F2EA, dark: 0x4E4A57),
                                                              background: DSColor.color(light: 0xF4F2EA, dark: 0x4E4A57),
                                                              text: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                              placeHolder: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6))
        
        primaryView = DSDesignableViewColors(button: DSDesignableButtonColor(background: DSColor.color(light: 0xFC8F0F, dark: 0xFC8F0F),
                                                                             title: DSColor.color(light: 0xffffff, dark: 0xffffff)),
                                             text: text,
                                             textField: primaryViewTextField,
                                             background: DSColor.color(light: 0xFFFCF8, dark: 0x383443),
                                             separator: DSColor.color(light: 0xFBEFE0, dark: 0x464154),
                                             cornerRadius: 13)
        
        // MARK: - Secondary view
        
        let secondaryText = DSDesignableTextColor(largeTitle: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                  title1: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                  title2: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                  title3: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                  headline: DSColor.color(light: 0x000000, dark: 0xE8E7E6),
                                                  subheadline: DSColor.color(light: 0x333333, dark: 0x999DB1),
                                                  body: DSColor.color(light: 0x2A2732, dark: 0xE8E7E6),
                                                  callout: DSColor.color(light: 0x595465, dark: 0x999DB1),
                                                  caption1: DSColor.color(light: 0x595465, dark: 0x999DB1),
                                                  caption2: DSColor.color(light: 0x595465, dark: 0x999DB1),
                                                  footnote: DSColor.color(light: 0x595465, dark: 0x999DB1))
        
        let secondaryViewTextField = DSDesignableTextFieldColor(border: DSColor.color(light: 0xffffff, dark: 0x383443),
                                                                background: DSColor.color(light: 0xffffff, dark: 0x383443),
                                                                text: text.headline,
                                                                placeHolder: text.subheadline)
        
        secondaryView = DSDesignableViewColors(button: DSDesignableButtonColor(background: DSColor.color(light: 0xFC8F0F, dark: 0xFC8F0F),
                                                                               title: DSColor.color(light: 0xffffff, dark: 0xffffff)),
                                               text: secondaryText,
                                               textField: secondaryViewTextField,
                                               background: DSColor.color(light: 0xF4F2EA, dark: 0x4E4A57),
                                               separator: DSColor.color(light: 0xDFDCD3, dark: 0x3D3A45),
                                               cornerRadius: 13)
        
        // MARK: - Tabbar
        
        tabBar = DSDesignableTabbarColor(barTint: primaryView.background,
                                         itemTint: primaryView.button.background,
                                         unselectedItemTint: text.subheadline,
                                         badge: self.brandColor)
        
        // MARK: - Navigation Bar
        
        navigationBar = DSDesignableNavigationBarColor(buttons: primaryView.button.background,
                                                       text: text.title1,
                                                       bar: primaryView.background)
        
        // MARK: - Price
        
        price = DSDesignablePriceColor(currency: self.brandColor,
                                       amount: self.brandColor,
                                       regularAmount: text.subheadline)
    }
}
