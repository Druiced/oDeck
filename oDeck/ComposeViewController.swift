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

class ComposeViewController: UIViewController {
    //notes https://www.youtube.com/watch?v=DGt1yBxBw9k
    @IBOutlet var a2: UILabel!
    @IBOutlet var h1: UILabel!
    @IBOutlet var h2: UILabel!
    @IBOutlet var i1: UILabel!
    @IBOutlet var i2: UILabel!
    @IBOutlet var j1: UILabel!
    @IBOutlet var j2: UILabel!
    @IBOutlet var k1: UILabel!
    @IBOutlet var k2: UILabel!
    @IBOutlet var l1: UILabel!
    @IBOutlet var l2: UILabel!
    @IBOutlet var m1: UILabel!
    @IBOutlet var m2: UILabel!
    @IBOutlet var n1: UILabel!
    @IBOutlet var n2: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            
                a2.text = "Select Card Value First"
            
            } else {

                i1.text = j1.text
                i2.text = j2.text
                j1.text = k1.text
                j2.text = k2.text
                k1.text = l1.text
                k2.text = l2.text
                l1.text = m1.text
                l2.text = m2.text
                self.n2.text = buttonDump
                m1.text = n1.text
                m2.text = n2.text
                n1.text = ""
                n2.text = ""
                inSequence.append(firstChar)
                a2.text = String(stringInterpolationSegment: inSequence)
                firstButton!.backgroundColor = UIColor.blueColor()
            
                //count number of hands
                h2.text = "\((count(inSequence)/2))"
            
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