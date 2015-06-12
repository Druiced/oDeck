//
//  customSignUpViewController.swift
//  oDeck
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 Andrew Douwes. All rights reserved.
//

import UIKit

class customSignUpViewController: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize PFSignUpView color and logo
        self.view.backgroundColor = UIColor.darkGrayColor()
        let logoView = UIImageView(image: UIImage(named: "oDeckLrg.png"))
        self.signUpView!.logo = logoView
        self.signUpView!.logo?.contentMode = UIViewContentMode.ScaleAspectFill
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
