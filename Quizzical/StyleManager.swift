//
//  StyleManager.swift
//  Quizzical
//
//  Created by Casey Conway on 4/29/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

//ABOUT - This file includes all the color settings for the app

import UIKit

struct StyleManager {
    //Colors for result text field when right or wrong answer selected
    static let correctColor = UIColor(red: 65.0/255, green: 145.0/255, blue: 135.0/255, alpha: 1.0)
    static let wrongColor = UIColor(red: 242.0/255, green: 166.0/255, blue: 110.0/255, alpha: 1.0)
    
    //Enabled/Disabled Button Color Settings
    static let enabledButtonBackgroundColor: UIColor = UIColor(red: 54/255.0, green: 119/255.0, blue: 147/255.0, alpha: 1.0)
    static let disabledButtonBackgroundColor: UIColor = UIColor(red: 54/255.0, green: 119/255.0, blue: 147/255.0, alpha: 0.5)
    static let enabledButtonTextColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let disabledButtonTextColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
}

