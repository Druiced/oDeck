//
//  KeyViewController.swift
//  oDeck
//
//  Created by Andrew on 5/25/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
import Parse

class KeyViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let buttonTags = ["e", "W", "X", "I", "T", "J", "Q", "C", "7", "8", "9", "D", "4", "5", "6", "H", "A", "2", "3", "S", "K"]
    
    // Used string because swift doesn't like empty Character
    // Button Press Placeholder
    var firstChar = ""
    var secondChar = ""
    
    // the sequence - every 2 characters in the string equals a card
    var inSequence = String()
    
    // Store the ID of the first button pressed (highlighting)
    var firstButtonId: Int!
    
    // Store character of button pressed
    var buttonChar = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Function builds columns and rows (addSubView). Image updates needed for better landscape support
        addFiveVer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    
    func navigationBarHeight () -> CGFloat {
       return self.navigationController!.navigationBar.frame.size.height
    }
    
    func updateTitle () {
        self.title = "Cards: \(count(inSequence) / 2)"
    }
    
    // Collection View for displaying selected cards
    // divide by 2 because 2 characters in inSequence per card
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count(inSequence) / 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor(red: 0.216, green: 0.231, blue: 0.216, alpha: 1)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        imageView.contentMode = UIViewContentMode.TopLeft
        
        // grab every 2 characters
        let str:NSString = inSequence
        let length = str.length
        let totalLlength:Int =  length/2
        let indexStart   = indexPath.row * (2)
        let aRange = NSMakeRange(indexStart, 2)
        let cardString:NSString = str.substringWithRange(aRange)
        let imageNameString = "c\(cardString).png"
        let front = UIImage(named: imageNameString)
        imageView.image = front
        cell.addSubview(imageView)
        
        return cell
    }
    

    func addFiveVer() {

        // master (vert) rows with addSubView of columns
        // recode without layout functions and make reusable
        
        let vLayout = VerticalLayout(width: view.frame.width)
        view.addSubview(vLayout)
        let naviConH = statusBarHeight() + navigationBarHeight()
        let row0 = UIView(frame: CGRectMake(0, 0, view.frame.width,  naviConH))
        row0.backgroundColor = UIColor(red: 0.216, green: 0.231, blue: 0.216, alpha: 1)
        vLayout.addSubview(row0)
        
        // Collection View Row
        let row1 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row1.backgroundColor = UIColor.magentaColor()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 55, height: (view.frame.height - naviConH) / 6)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 1.0
        collectionView = UICollectionView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6), collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor(red: 0.216, green: 0.231, blue: 0.216, alpha: 1)
        row1.addSubview(collectionView!)
        vLayout.addSubview(row1)
        
        // Button Row 1 of 5
        let row2 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row2.backgroundColor = UIColor.blueColor()
        
        // W and X are blank fillers for now - Had to move K to tag20, Swift didn't allow assigning tag = 0
        addFourHor(row2, img0: "K.png", img1: "W.png", img2: "X.png", img3: "delete.png", tag0: 20, tag1: 1, tag2: 2, tag3: 3)
        vLayout.addSubview(row2)

        // Button Row 2 of 5
        let row3 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row3.backgroundColor = UIColor.yellowColor()
        addFourHor(row3, img0: "T.png", img1: "J.png", img2: "Q.png", img3: "C.png", tag0: 4, tag1: 5, tag2: 6, tag3: 7)
        vLayout.addSubview(row3)

        // Button Row 3 of 5
        let row4 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row4.backgroundColor = UIColor.blackColor()
        addFourHor(row4, img0: "7.png", img1: "8.png", img2: "9.png", img3: "DR.png", tag0: 8, tag1: 9, tag2: 10, tag3: 11)
        vLayout.addSubview(row4)
        
        // Button Row 4 of 5
        let row5 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row5.backgroundColor = UIColor.greenColor()
        addFourHor(row5, img0: "4.png", img1: "5.png", img2: "6.png", img3: "HR.png", tag0: 12, tag1: 13, tag2: 14, tag3: 15)
        vLayout.addSubview(row5)
        
        // Button Row 5 of 5
        let row6 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row6.backgroundColor = UIColor.cyanColor()
        addFourHor(row6, img0: "A.png", img1: "2.png", img2: "3.png", img3: "S.png", tag0: 16, tag1: 17, tag2: 18, tag3: 19)
        vLayout.addSubview(row6)
    }
    
    func addFourHor(viewName: UIView, img0: String, img1: String, img2: String, img3: String, tag0: Int, tag1: Int, tag2: Int, tag3: Int) {
        var hLayout = HorizontalFitLayout(height: viewName.frame.height)
        hLayout.backgroundColor = UIColor(red: 0.459, green: 0.486, blue: 0.459, alpha: 1)
        viewName.addSubview(hLayout)

        // Column 1 of 4
        let view0 = UIButton(frame: CGRectMake(0, 0, view.frame.width / 4, hLayout.frame.height))
        let image0 = UIImage(named: img0)
        view0.tag = tag0
        view0.setImage(image0, forState: .Normal)
        view0.contentMode = UIViewContentMode.ScaleToFill
        view0.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        hLayout.addSubview(view0)
        
        // Column 2 of 4
        let view1 = UIButton(frame: CGRectMake(0, 0, view.frame.width / 4, hLayout.frame.height))
        let image1 = UIImage(named: img1)
        view1.tag = tag1
        view1.setImage(image1, forState: .Normal)
        view1.contentMode = UIViewContentMode.ScaleToFill
        view1.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        hLayout.addSubview(view1)
        
        // Column 3 of 4
        let view2 = UIButton(frame: CGRectMake(0, 0, view.frame.width / 4, hLayout.frame.height))
        let image2 = UIImage(named: img2)
        view2.tag = tag2
        view2.setImage(image2, forState: .Normal)
        view2.contentMode = UIViewContentMode.ScaleToFill
        view2.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        hLayout.addSubview(view2)
        
        // Column 4 of 4
        let view3 = UIButton(frame: CGRectMake(0, 0, view.frame.width / 4, hLayout.frame.height))
        let image3 = UIImage(named: img3)
        view3.tag = tag3
        view3.setImage(image3, forState: .Normal)
        view3.contentMode = UIViewContentMode.ScaleToFill
        
        // if backspace tag, point to backspace function instead
        if view3.tag == 3 {
            view3.addTarget(self, action: "backSpace:", forControlEvents: UIControlEvents.TouchUpInside)
        } else {
            view3.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        hLayout.addSubview(view3)
    
    }

    @IBAction func seqTouched(theButton: UIButton) {

        // The button has been pressed
        buttonChar = buttonTags[theButton.tag]
        
        if buttonChar == "C" || buttonChar == "D" || buttonChar == "H" || buttonChar == "S" {
            if firstChar == "" {
                
                println("Select Card Value First")
                
            } else {
                
                secondChar = buttonChar
                inSequence.append(Character(secondChar))
                firstChar = ""
                secondChar = ""
                
                resetTheButton()
               
                updateTitle()
                
                bounceToEnd()
                
            }
        
        } else {
            
            // Sometimes the user will change their mind.
            if firstChar != "" {
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                resetTheButton()
            }
            
            // Set first button variables and change to highlighted image ending with R.png
            firstChar = buttonChar
            firstButtonId = theButton.tag
            inSequence.append(Character(firstChar))
            let oneButton = self.view.viewWithTag(theButton.tag) as! UIButton
            let image0 = UIImage(named: "\(buttonTags[theButton.tag])R.png")
            oneButton.setImage(image0, forState: .Normal)
    
        }

    }


    func resetTheButton() {
        
        // It would be silly not to change back to the non-highlighted color
        // Good thing we stored the previous button pressed in firstButtonId
        
        let oneButton = self.view.viewWithTag(firstButtonId) as! UIButton
        let image0 = UIImage(named: "\(buttonTags[firstButtonId]).png")
        oneButton.setImage(image0, forState: .Normal)
        firstChar = ""
        
    }
    
    func bounceToEnd() {
        
        // Reload Collection View - Bounce it to the last card.
        
        collectionView?.reloadData()

        if count(inSequence) % 2 == 0 && count(inSequence) > 1 {
            
            var item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            var lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
            self.collectionView?.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        
        }
        
    }
    
    @IBAction func backSpace(sender: AnyObject) {
        
        // we have to consider if the user is hitting backspace after only touching a 'first button'
        // the first button is already appended to the inSequence String, so lets remove it
        
        if inSequence != "" {
            
            if firstChar != "" {
                
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                resetTheButton()
                
            } else {
                
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
            
            }
            
        }

        updateTitle()
        
        bounceToEnd()
    
    }
    
    @IBAction func saveSequence(sender: AnyObject) {
        
        //        noRefresh = false  // need to add a noRefresh boolean. No need to always refresh
        let testObject = PFObject(className: "oDeck")
        testObject["Sequence"] = inSequence
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
