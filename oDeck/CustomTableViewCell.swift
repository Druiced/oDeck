//
//  CustomTableViewCell.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 Andrew Douwes. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var foldersCollectionView: UICollectionView!

    var stringForCell:String = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Count number of cards for each UICollectionView within each UITableViewCell
    // This addressed data issues when quickly scrolling the Table and Collection views
    var folderCount:Int?
        {
        didSet(value)
        {
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Configure UICollectionView Layout
        var aFlowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        aFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        aFlowLayout.itemSize = CGSizeMake(112.0, 156.0)
        aFlowLayout.minimumLineSpacing = 5.0
        aFlowLayout.minimumInteritemSpacing = 0.0
        aFlowLayout.sectionInset = UIEdgeInsetsMake(2, 9, 0, 10)
        foldersCollectionView.collectionViewLayout = aFlowLayout
        foldersCollectionView.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "FOLDER_CELL")
        var cNib:UINib? = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        foldersCollectionView.registerNib(cNib, forCellWithReuseIdentifier: "FOLDER_CELL")
        foldersCollectionView.frame = self.bounds

    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }
    
    
    // Custom TableViewCell for each sequence
    class func CreateCustomCell() -> CustomTableViewCell
    {
        var nibElements: Array = NSBundle.mainBundle().loadNibNamed("CustomTableViewCell", owner: self, options: nil)
        var item: AnyObject?
        
        for item in nibElements
        
        {
            
            if item is UITableViewCell
            
            {
            
                return item as! CustomTableViewCell
 
            }
        
        }
        
        return item as! CustomTableViewCell
    
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell :CustomCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier("FOLDER_CELL", forIndexPath: indexPath) as? CustomCollectionViewCell

        // Build 2 character filename from sequence string
        var str:NSString = stringForCell
        var length = str.length
        var totalLlength:Int =  length/2
        var indexStart   = indexPath.row * (2);
        var aRange = NSMakeRange(indexStart, 2)
        var cardString:NSString = str.substringWithRange(aRange)
        cell?.aLabel.text   = "\(indexPath.row + 1)"
        cell?.aLabel.textAlignment = NSTextAlignment.Center
        let imageNameString = "\(cardString).png"
        let front = UIImage(named: imageNameString)
        cell?.imageView.image = front
        return cell!
    
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var str:NSString = stringForCell
        var length:Int = str.length
        return length / 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
