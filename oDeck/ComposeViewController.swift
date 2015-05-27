//
//  ViewController.swift
//  Smart Deck Of Cards
//
//  Created by Andrew on 4/12/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
import Parse

//var deviceId: String?

class ComposeViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource  {
    //notes https://www.youtube.com/watch?v=DGt1yBxBw9k
    @IBOutlet var a2: UILabel!
    @IBOutlet var n1: UILabel!
    @IBOutlet var n2: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }

    //
    
    
/*    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        
        var str:NSString = inSequence
        var length = str.length
        var totalLlength:Int =  length/2
        var indexStart   = indexPath.row * (2);
        var aRange = NSMakeRange(indexStart, 2)
        var cardString:NSString = str.substringWithRange(aRange)
        
        let imageNameString = "\(cardString).png"
        let front = UIImage(named: imageNameString)
        
        //cell.ImageView.backgroundColor = UIColor.orangeColor()
        cellImage.image = front
        //        cell!.imageView.contentMode = UIViewContentMode.ScaleToFill
        
        //        cell?.imageView.contentMode = UIViewContentMode.Center
        //front.contentMode = UIViewContentMode.ScaleToFill
        
        //     cell?.aLabel.text = "Card:\(indexPath.row)"
        //        println("indexPath: \(indexPath.row)")
        println("indexPath: \(indexPath.row)")
        
        //        cell?.aLabel.text = "Card:\(sequenceArray[indexPath.row])"
        
        println("Card: \(indexPath.row)")
        // lay out each card by index path starting with 0 for the 0th card
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var str:NSString = stringForCell
        var length:Int = str.length
        return length / 2
        
        //        return folderCount!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
*/
//
    
    
    @IBAction func saveSequence(sender: AnyObject) {
       
//        noRefresh = false

        let testObject = PFObject(className: "oDeck")
        let stringHolder = String(stringInterpolationSegment: inSequence)

        testObject["Sequence"] = stringHolder.stringByReplacingOccurrencesOfString(" ", withString: "")
        println("Saving inSequence: \(inSequence)")
        
        deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        testObject["Device"] = deviceId
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            
            println("Object has been saved.")
        
            var objectID = testObject.objectId
            println("Object iD is: \(objectID)")

        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    var inSequence = String()
    var firstButton: UIButton?
    
    @IBAction func buttonTapped(theButton: UIButton) {
 
        var buttonDump = theButton.titleLabel!.text!
        var firstChar = Array(buttonDump)[0]
        if firstChar == "1" { firstChar = "T" }
        if firstChar == "♣️" { firstChar = "C" }
        if firstChar == "♦️" { firstChar = "D" }
        if firstChar == "♥️" { firstChar = "H" }
        if firstChar == "♠️" { firstChar = "S" }
        
        if firstChar == "C" || firstChar == "D" || firstChar == "H" || firstChar == "S" {

            if self.n1.text == "" {
            
                println("Select Card Value First")
            
            } else {

                self.n2.text = buttonDump
                n1.text = ""
                n2.text = ""
                inSequence.append(firstChar)
                println(String(stringInterpolationSegment: inSequence))
                firstButton!.backgroundColor = UIColor.blueColor()
            
                //count number of hands
                a2.text = "\((count(inSequence)/2))"
            
            }
            
        } else {

            // In case user changes their mind on which card value to select
            if self.n1.text != "" {
                firstButton!.backgroundColor = UIColor.blueColor()
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
            }

            self.n1.text = buttonDump
            inSequence.append(firstChar)
            firstButton = theButton
            firstButton!.backgroundColor = UIColor.yellowColor()

        }

    }
    
}