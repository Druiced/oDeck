//
//  ViewController.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
import Parse

var deviceId: String?

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    
    var timeLineData:NSMutableArray = NSMutableArray()
    var sequenceArray = [String]()
    var cardCountArray:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardCountArray = [5,15,6,12,7,10,20,1,2,7,25,20,3,1,2,3,4,23,4,5,7,6,4,3,5,2,1,4,5,6,8,9,1,2,3,4,11,2,3,45,5,2,4,5,6,2,2,1,4,5,67,5,4,7,8,9,2,1,2,3,3,3,3,31,1,1,12,3,42,1,2,34,4,5,2,2,1,4,5,4,1,2,34,5,5,5,4,21,2,3,3,11,23,3,32,1]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return cardCountArray.count
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
        cell?.folderCount = cardCountArray[indexPath.section]
        cell?.foldersCollectionView.reloadData()
        cell?.clipsToBounds = true
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerView:UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 20.0))
        
        var hLayout = HorizontalFitLayout(height: 20)
        hLayout.backgroundColor = UIColor.cyanColor()
        headerView.addSubview(hLayout)
        
        let view1 = UILabel(frame: CGRectMake(0, 0, 75, 20))
        view1.backgroundColor = UIColor.redColor()
        view1.textAlignment = .Center
        view1.text = ("\(section)")
        hLayout.addSubview(view1)
        
        let view2 = UILabel(frame: CGRectMake(0, 0, 0, 20))
        view2.backgroundColor = UIColor.magentaColor()
        view2.text = ("05/21/15 @ 20:48")
        view2.textAlignment = .Center
        hLayout.addSubview(view2)
        
        let view3 = UILabel(frame: CGRectMake(0, 0, 75, 20))
        view3.backgroundColor = UIColor.greenColor()
        view3.text = ("\(cardCountArray[section])")
        view3.textAlignment = .Center
        hLayout.addSubview(view3)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
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

    @IBAction func loadData() {
        
        // Load Parse.com data
        timeLineData.removeAllObjects()
        sequenceArray.removeAll()
        
        var findTimelineData = PFQuery(className:"KickDeck")
        findTimelineData.whereKey("Device", equalTo:deviceId!)
        findTimelineData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in reverse(objects) {
                        println(object.objectId)
                        self.timeLineData.addObject(object)
                        println("\(self.timeLineData.count)")
                    }
                    
                    for (index, item) in enumerate(self.timeLineData) {
                        
                        let deck:PFObject = self.timeLineData.objectAtIndex(index) as! PFObject
                        let seq = deck.objectForKey("Sequence") as! String
                        self.sequenceArray.insert(seq, atIndex: index)
                        
                    }
                    
//                    tableView.reloadData()
                    
                }
                
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }

    
}

