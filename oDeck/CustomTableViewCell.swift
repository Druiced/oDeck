//
//  CustomTableViewCell.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var foldersCollectionView: UICollectionView!
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //    }
    
    required init(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    var folderCount:Int?
        {
        didSet(value)
        {
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //configure our collectionview
        var aFlowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        aFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        aFlowLayout.itemSize = CGSizeMake(60.0, 90.0)
        aFlowLayout.minimumLineSpacing = 10.0
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
        
        // Configure the view for the selected state
    }
    
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
        cell?.aLabel.text = "Card:\(indexPath.row)"
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folderCount!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}
