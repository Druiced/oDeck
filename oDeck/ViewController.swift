//
//  ViewController.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
//test push from xcode
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
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
        
        var headerView:UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 70.0))
        var labelTitle:UILabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 35))
        var descriptionTitle:UILabel = UILabel(frame: CGRectMake(0, 20,tableView.bounds.size.width , 30))
        headerView.addSubview(labelTitle)
        headerView.addSubview(descriptionTitle)
        labelTitle.text = "TOTAL_CARDS in section:\(section)"
        descriptionTitle.text = "This CARD_SECTION contains \(cardCountArray[section]) CARDS"
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
}

