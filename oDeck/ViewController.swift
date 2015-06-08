//
//  ViewController.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
import Parse
import ParseUI

var deviceId: String?
var sequenceArray = [String]()
var dateArray = [String]()
var idArray = [String]()
// add bounce to collection view, if pull last collection view, it will bounce to the other end

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var timeLineData:NSMutableArray = NSMutableArray()
    var cardCountArray:[Int] = []

    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    override func viewDidAppear(animated: Bool) {
        //   if noRefresh == false {
        loadData()
        //noRefresh = true
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        hLayout.backgroundColor = UIColor.cyanColor()
        headerView.addSubview(hLayout)

        // TOP LEFT Section Counter for now
        let view1 = UIButton(frame: CGRectMake(0, 0, 120, 20))
        view1.backgroundColor = UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
//        view1.shadowColor = UIColor.whiteColor()
//        view1.textColor = UIColor.blueColor()
//        view1.textAlignment = .Center
        view1.setTitleColor(UIColor.blueColor(), forState: .Normal)
        view1.setTitle("\(idArray[section])", forState: .Normal)
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
        let view3 = UILabel(frame: CGRectMake(0, 0, 100, 20))
        view3.backgroundColor =  UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
        view3.textColor = UIColor.whiteColor()
        view3.text = ("\(cellCardCount) Cards")
        view3.textAlignment = .Right
        hLayout.addSubview(view3)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func seqTouched(sender: UIButton!) {
        var buttonTag:UIButton = sender

        let someText:String = "\(buttonTag.tag) \(idArray[buttonTag.tag])"
        let google:NSURL = NSURL(string:"http://google.com/")!
        
        // let's add a String and an NSURL
        let activityViewController = UIActivityViewController(
            activityItems: [someText, google],
            applicationActivities: nil)
        self.navigationController!.presentViewController(activityViewController,
            animated: true, 
            completion: nil)
        
    }
    

    @IBAction func loadData() {
        // Load Parse.com data
        timeLineData.removeAllObjects()
        sequenceArray.removeAll()
        var findTimelineData = PFQuery(className:"oDeck")
        findTimelineData.whereKey("Device", equalTo:deviceId!)
        findTimelineData.orderByDescending("updatedAt")
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        self.timeLineData.addObject(object)
                        println("\(self.timeLineData.count)")
                    }
                    
                    for (index, item) in enumerate(self.timeLineData) {
                        let deck:PFObject = self.timeLineData.objectAtIndex(index) as! PFObject
                        let seq = deck.objectForKey("Sequence") as! String
                        sequenceArray.insert(seq, atIndex: index)
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd hh:mm:ss"
                        dateArray.insert(dateFormatter.stringFromDate(deck.updatedAt!), atIndex: index)
                        let sId = deck.objectId
                        println("sID: \(sId)")
                        idArray.insert(sId!, atIndex: index)
                    }
                    self.tableView.reloadData()
                }
            } else {
            }
        }
    }
}

class HorizontalLayout: UIView {
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
