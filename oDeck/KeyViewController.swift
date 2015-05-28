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
    let buttonTags = ["e", "W", "X", "I", "T", "J", "Q", "S", "7", "8", "9", "D", "4", "5", "6", "H", "A", "2", "3", "S", "K"]
    
    // Had to use String instead of Character becuase Swift doesn't like empty character variables
    var firstChar = ""
    // These store buttones pressed to complete a pair of buttons
    var secondChar = ""
    // Stores our string that will be appended, modified and saved to database
    var inSequence = String()
    //    var firstButton: Int? // Storing button information - before required to use tags, can delete
    
    // Store first button ID so we can swap it back to normal image (not highlighted)
    var firstButtonId: Int!
    // Logic below goes off of character instead of tag, should be able to consolidate to tags only
    var buttonChar = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFiveVer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    

    func addFiveVer() {
        //master (vert) rows with addSubView of columns
        //this can be pulled into reusable functions later
        
        view.backgroundColor = UIColor.lightGrayColor()
        
        var vLayout = VerticalLayout(width: view.frame.width)
        vLayout.backgroundColor = UIColor.cyanColor()
        view.addSubview(vLayout)
        let naviConH = CGFloat(self.navigationController!.navigationBar.frame.size.height)
        let row0 = UIView(frame: CGRectMake(0, 0, view.frame.width,  naviConH))
        row0.backgroundColor = UIColor.redColor()
        vLayout.addSubview(row0)
        
/*      This is the row hidden behind the stats or control bar
        let col0Row1 = UIView(frame: CGRectMake(0, 0, 100, view.frame.height))
        col0Row1.backgroundColor = UIColor.yellowColor()
        col0.addSubview(col0Row1)
*/
        
        let row1 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row1.backgroundColor = UIColor.magentaColor()

/*        let collectionTop = UICollectionView(frame: CGRectMake(0, 0, view.frame.width / 4, (view.frame.height - naviConH) / 6))
        collectionTop.backgroundColor = UIColor.greenColor()
        row1.addSubview(collectionTop)
*/
// 34

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: 72, height: 100)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView = UICollectionView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6), collectionViewLayout: layout)

        collectionView!.dataSource = self
        collectionView!.delegate = self
    
        
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()

        
        row1.addSubview(collectionView!)
        vLayout.addSubview(row1)
        
        let row2 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row2.backgroundColor = UIColor.blueColor()
        // W and X are blank fillers for now - Had to move K to tag20, Swift didn't allow assigning tag = 0
        addFourHor(row2, img0: "K.png", img1: "W.png", img2: "X.png", img3: "delete.png", tag0: 20, tag1: 1, tag2: 2, tag3: 3)
        vLayout.addSubview(row2)


        let row3 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row3.backgroundColor = UIColor.yellowColor()
       
        addFourHor(row3, img0: "T.png", img1: "J.png", img2: "Q.png", img3: "S.png", tag0: 4, tag1: 5, tag2: 6, tag3: 7)
        vLayout.addSubview(row3)

        let row4 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row4.backgroundColor = UIColor.blackColor()
        addFourHor(row4, img0: "7.png", img1: "8.png", img2: "9.png", img3: "DR.png", tag0: 8, tag1: 9, tag2: 10, tag3: 11)
        vLayout.addSubview(row4)
        
        let row5 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row5.backgroundColor = UIColor.greenColor()
        addFourHor(row5, img0: "4.png", img1: "5.png", img2: "6.png", img3: "HR.png", tag0: 12, tag1: 13, tag2: 14, tag3: 15)
        vLayout.addSubview(row5)
        
        let row6 = UIView(frame: CGRectMake(0, 0, view.frame.width, (view.frame.height - naviConH) / 6))
        row6.backgroundColor = UIColor.cyanColor()
        addFourHor(row6, img0: "A.png", img1: "2.png", img2: "3.png", img3: "S.png", tag0: 16, tag1: 17, tag2: 18, tag3: 19)
        vLayout.addSubview(row6)

        println("viewW: \(view.frame.width / 4)")
        println("viewH: \((view.frame.height - naviConH) / 6)")
        
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
        
            println("view2 tag: \(view2.tag) equals 3")
        } else {
        view3.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
            println("view2 tag: \(view2.tag) is not 3")

        }
        hLayout.addSubview(view3)
    }

    
    @IBAction func seqTouched(theButton: UIButton) {
        
        println("ButtonDump: \(theButton.tag)")
        println("Button: \(buttonTags[theButton.tag])")
        
        buttonChar = buttonTags[theButton.tag]
        
        if buttonChar == "C" || buttonChar == "D" || buttonChar == "H" || buttonChar == "S" {
            
            if firstChar == "" {
                
                println("Select Card Value First")
                
            } else {
                
                secondChar = buttonChar
                
                inSequence.append(Character(secondChar))
                
                println("Appended \(secondChar)")
                println("seq: \(inSequence)")
                firstChar = ""
                secondChar = ""
                resetTheButton()
                }
        
        } else {
            //if user changes their made and picks a different first char
            
            
          
            if firstChar != "" {
                println("Setbutton Background Back to Normal and remove from char from array")
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
      

                resetTheButton()
                
            }
            
            firstChar = buttonChar
            firstButtonId = theButton.tag
            inSequence.append(Character(firstChar))
            println("Append 1st Char: \(firstChar)")

            let oneButton = self.view.viewWithTag(theButton.tag) as! UIButton
            let image0 = UIImage(named: "\(buttonTags[theButton.tag])R.png")
            
            oneButton.setImage(image0, forState: .Normal)
            
            //            let bMark = self.view.viewWithTag(5) as? UIButton

            //            bMark?.setTitle("TE", forState: .Normal)
            //change to highlight button back
        }
        
    println("SEQ: \(inSequence)")
    }


    func resetTheButton() {
        let oneButton = self.view.viewWithTag(firstButtonId) as! UIButton
        let image0 = UIImage(named: "\(buttonTags[firstButtonId]).png")
        oneButton.setImage(image0, forState: .Normal)
        firstChar = ""
    }
    
    @IBAction func backSpace(sender: AnyObject) {
        
        if inSequence != "" {
            if firstChar != "" {
                
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                resetTheButton()
                println("Remove1: \(inSequence)")
                
            } else {
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                inSequence.removeAtIndex(inSequence.endIndex.predecessor())
                println("Remove2: \(inSequence)")
            }
            }
        
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
