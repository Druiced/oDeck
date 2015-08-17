//
//  ViewController.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 Andrew Douwes. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var sequenceArray = [String]()
var dateArray = [String]()
var idArray = [String]()

// prevents loadData function from accessing Parse before a
// new sequence has been added
var noLoadData: Bool = false

// Overview in order
// Global Variables
// View Load Functions
// Parse.com Login and Signup Controllers
// Table View with Sharing Feature
// Load Data from Parse Function
// Function for Vertical and Horizontal Spacing

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timeLineData:NSMutableArray = NSMutableArray()
    var cardCountArray:[Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Call orientationChanged function if user changes orientation
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }
    
    func orientationChanged() {
        
        // reload the table for new orientation
        self.tableView.reloadData()
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Parse user signup or login
        if (PFUser.currentUser() == nil) {
            
            // if a user logs out then in, reload data
            noLoadData = false
            
            var logInViewController = customLogInViewController()
            logInViewController.delegate = self
            
            var signUpViewController = customSignUpViewController()
            signUpViewController.delegate = self

            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
        } else {
            
            loadData()

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Start ParseUI
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            
            return true
            
        } else {
            
            return false
        
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        // user login success
        self.dismissViewControllerAnimated(true, completion: nil)
 
    }
 
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
    
        var alert = UIAlertController(title: "oDeck Database Login", message: "Invalid Credentials - Login Failed", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!) in
        }))
    
        // failed to login
        logInController.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
    

        let parseLogin = info["username"] as? String
        let parsePass = info["password"] as? String
        let parseEmail = info["email"] as? String
        
        if count(parsePass!.utf16) <= 7 {
            var alert = UIAlertController(title: "oDeck Quick Signup", message: "Password must be at least 8 long", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!) in
            }))
            
            signUpController.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        if parseEmail == "" {
            var alert = UIAlertController(title: "oDeck Quick Signup", message: "E-mail used to retrieve password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (ACTION :UIAlertAction!) in
            }))
            
            signUpController.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        if let password = info["password"] as? String {
            
            return count(password.utf16) >= 8
            
        }
        
        return false
    
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
       
        // failed to sign up
    
    }
    
    // Parse Sign Off
    @IBAction func signOff(sender: AnyObject) {
        
        PFUser.logOut()
        timeLineData.removeAllObjects()
        sequenceArray.removeAll()
        self.title = "Please Login"
        self.tableView.reloadData()
        self.viewDidAppear(true)
    
    }

    // End ParseUI
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return timeLineData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:CustomTableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL") as? CustomTableViewCell;

        if(cell == nil)
        {
            cell = CustomTableViewCell.CreateCustomCell()
        }
        cell?.stringForCell = sequenceArray[indexPath.section]
        cell?.foldersCollectionView.reloadData()
        cell?.clipsToBounds = true
        
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 160.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView:UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 20.0))
        var str:NSString = sequenceArray[section]
        var length:Int = str.length
        let cellCardCount = length / 2
        var hLayout = HorizontalFitLayout(height: 20)
        headerView.addSubview(hLayout)

        // TOP LEFT
        let view1 = UIButton(frame: CGRectMake(0, 0, 100, 20))
        view1.backgroundColor = UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
        view1.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        view1.setTitle("Share", forState: .Normal)
        view1.titleLabel?.textAlignment = .Left
        view1.tag = section
        view1.addTarget(self, action: "seqTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        hLayout.addSubview(view1)
        
        // TOP CENTER Date Display
        let view2 = UILabel(frame: CGRectMake(0, 0, 0, 20))
        view2.backgroundColor =  UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
        view2.textColor = UIColor.whiteColor()
        view2.text = ("\(dateArray[section])")
        view2.textAlignment = .Center
        hLayout.addSubview(view2)

        // TOP RIGHT Card Count
        
        let view3 = UIButton(frame: CGRectMake(0, 0, 100, 20))
        view3.backgroundColor = UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
        view3.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        view3.setTitle("\(cellCardCount) Cards", forState: .Normal)
        view3.titleLabel?.textAlignment = .Right
        view3.tag = section
        view3.addTarget(self, action: "delSeq:", forControlEvents: UIControlEvents.TouchUpInside)
        
        hLayout.addSubview(view3)

        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func seqTouched(sender: UIButton!) {
        
        // Sharing Feature
        
        var buttonTag:UIButton = sender
        let str:NSString = sequenceArray[buttonTag.tag]
        let id:NSString = idArray[buttonTag.tag]
        let length = str.length
        let totalLlength:Int =  length / 2
        let someText:String = "I just logged \(totalLlength) cards with oDeck.net:"
        let odeckurl:NSURL = NSURL(string:"http://odeck.net/?id=\(id)")!
        let activityViewController = UIActivityViewController(
            activityItems: [someText, odeckurl],
            applicationActivities: nil)
        self.navigationController!.presentViewController(activityViewController,
            animated: true,
            completion: nil)
    
    }

    func delSeq(sender: UIButton!) {
        
        // Option to delete sequences - Needs work
        
        var buttonTag:UIButton = sender
        let str:NSString = sequenceArray[buttonTag.tag]
        let id:String = idArray[buttonTag.tag]
        let length = str.length
        let totalLlength:Int =  length / 2
        
        var refreshAlert = UIAlertController(title: "oDeck.net", message: "Ok to delete this \(totalLlength) card set?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            var object:PFObject = PFObject(withoutDataWithClassName: "oDeck", objectId: id)
            object.deleteInBackground()

            // Should be able to delete row and animate without using loadData()
            // Disabling table until new data is loaded
            self.tableView.userInteractionEnabled = false
            self.tableView.alpha = 0.5
            noLoadData = false
            self.loadData()
        
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            println("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
    }

    
    
    @IBAction func loadData() {
        
        // Load user database from Parse.com
        if noLoadData == false {
            
            self.title = "Connected"
            timeLineData.removeAllObjects()
            sequenceArray.removeAll()
            var findTimelineData = PFQuery(className:"oDeck")
            findTimelineData.limit = 50
            findTimelineData.whereKey("Username", equalTo: PFUser.currentUser()!)
            
            findTimelineData.orderByDescending("updatedAt")
            findTimelineData.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {

                    // Successfully retrieved objects
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            self.timeLineData.addObject(object)

                        }
                        
                        for (index, item) in enumerate(self.timeLineData) {
                            let deck:PFObject = self.timeLineData.objectAtIndex(index) as! PFObject
                            let seq = deck.objectForKey("Sequence") as! String
                            sequenceArray.insert(seq, atIndex: index)
                            

                            // Set the date formatting - seconds seems fitting if logging multiple hands
                            var dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "MM/dd hh:mm:ss"
                            dateArray.insert(dateFormatter.stringFromDate(deck.updatedAt!), atIndex: index)
                            let sId = deck.objectId
                            idArray.insert(sId!, atIndex: index)
                       
                        }
                        
                        self.tableView.reloadData()
                        
                        // delSeq() delete sequence workaround
                        self.tableView.userInteractionEnabled = true
                        self.tableView.alpha = 1

                        
                        // update title with # of sequences
                        self.title = "Sets (\(self.timeLineData.count))"
                        
                        // jump tableview to top
                        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                        
                        noLoadData = true
                    
                    }
                
                } else {
                
                }
            
            }
        
        }

    }
}

class HorizontalLayout: UIView {
    
    // Came accross this class in a blog I read
    // This helps auto-align viritical or horizontal objects
    // While making this project I have come up with a different
    // way I will handle this in the future
    
    var xOffsets: [CGFloat] = []
    init(height: CGFloat) {
        super.init(frame: CGRectMake(0, 0, 0, height))
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var width: CGFloat = 0
        for i in 0..<subviews.count {
            var view = subviews[i] as! UIView
            view.layoutSubviews()
            width += xOffsets[i]
            view.frame.origin.x = width
            width += view.frame.width
        }
        self.frame.size.width = width
    }
    
    override func addSubview(view: UIView) {
        xOffsets.append(view.frame.origin.x)
        super.addSubview(view)
    }
    
    func removeAll() {
        for view in subviews {
            view.removeFromSuperview()
        }
        xOffsets.removeAll(keepCapacity: false)
    }
}

class HorizontalFitLayout: HorizontalLayout {
    override init(height: CGFloat) {
        super.init(height: height)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        var width: CGFloat = 0
        var zeroWidthView: UIView?
        
        for i in 0..<subviews.count {
            var view = subviews[i] as! UIView
            width += xOffsets[i]
            if view.frame.width == 0 {
                zeroWidthView = view
            } else {
                width += view.frame.width
            }
        }
        
        if width < superview!.frame.width && zeroWidthView != nil {
            zeroWidthView!.frame.size.width = superview!.frame.width - width
        }
        super.layoutSubviews()
    }
}

class VerticalLayout: UIView {
    
    var yOffsets: [CGFloat] = []
    
    init(width: CGFloat) {
        super.init(frame: CGRectMake(0, 0, width, 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        
        for i in 0..<subviews.count {
            var view = subviews[i] as! UIView
            view.layoutSubviews()
            height += yOffsets[i]
            view.frame.origin.y = height
            height += view.frame.height
        }
        
        self.frame.size.height = height
        
    }
    
    override func addSubview(view: UIView) {
        
        yOffsets.append(view.frame.origin.y)
        super.addSubview(view)
        
    }
    
    func removeAll() {
        
        for view in subviews {
            view.removeFromSuperview()
        }
        yOffsets.removeAll(keepCapacity: false)
        
    }
    
}


class VerticalScreenLayout: VerticalLayout {
    
    
    init() {
        super.init(width: UIScreen.mainScreen().bounds.width)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.frame.size.width = UIScreen.mainScreen().bounds.width
        super.layoutSubviews()
        
    }
    
}


class VerticalFitLayout: VerticalLayout {
    
    
    override init(width: CGFloat) {
        super.init(width: width)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        var height: CGFloat = 0
        var zeroHeightView: UIView?
        
        for i in 0..<subviews.count {
            var view = subviews[i] as! UIView
            height += yOffsets[i]
            if view.frame.height == 0 {
                zeroHeightView = view
            } else {
                height += view.frame.height
            }
        }
        
        if height < superview!.frame.height && zeroHeightView != nil {
            zeroHeightView!.frame.size.height = superview!.frame.height - height
        }
        
        super.layoutSubviews()
        
    }
    
}
