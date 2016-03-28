//
//  Meme.swift
//  MemeMe
//
//  Created by admin on 24/03/16.
//  Copyright © 2016 antt. All rights reserved.
//

import UIKit

class Meme {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage : UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage : UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }

}