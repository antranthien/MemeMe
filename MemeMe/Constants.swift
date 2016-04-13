//
//  Constants.swift
//  MemeMe
//
//  Created by admin on 24/03/16.
//  Copyright © 2016 antt. All rights reserved.
//


import UIKit

struct Constants {
    struct Meme {
        static let textAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        struct DefaultText {
            static let bottom = "BOTTOM"
            static let top = "TOP"
        }
        
        struct Tag {
            static let bottom = 2
            static let top = 1
        }

    }
}