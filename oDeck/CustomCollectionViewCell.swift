//
//  CustomCollectionViewCell.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var aLabel: UILabel!  //to show the card number
    @IBOutlet weak var imageView: UIImageView! //imageview i am setting it's background color
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
