//
//  UIThemeableSwitch.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableSwitch: UISwitch {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        updateAppearance(animated: false)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appearanceDidChange),
                                               name: .AppearanceDidChange,
                                               object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light && UserPreferences.shouldUseSystemLightDarkMode {
                
                UserPreferences.appTheme = 0
                updateAppearance(animated: true)
            }
            if traitCollection.userInterfaceStyle == .dark && UserPreferences.shouldUseSystemLightDarkMode {
                
                UserPreferences.appTheme = UserPreferences.trueBlackDarkTheme ? 2 : 1
                updateAppearance(animated: true)
            }
        }
    }
    
}

// MARK: - AppearanceModifiable
extension UIThemeableSwitch: AppearanceModifiable {
    
    func updateAppearance(animated: Bool) {
        
        // During the animation the UISwitch briefly looses its corner radius.
        // We set it prior to the animation starting to prevent this.
        layer.cornerRadius = 16
        clipsToBounds = true
        
        // Perform animation
        if animated {
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.updateAppearance(animated: false)
            })
        } else {
            onTintColor = UserPreferences.accentColor
        }
    }
    
    
    static func updateAppearance() {
        UIThemeableSwitch.appearance().onTintColor = UserPreferences.accentColor
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }
}