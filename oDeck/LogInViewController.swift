//
//  LogInViewController.swift
//  oDeck
//
//  Created by Andrew on 6/8/15.
//  Copyright (c) 2015 druiced. All rights reserved.
//

import UIKit
import ParseUI

class LogInViewController: UIViewController, PFLogInViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var logInViewController = PFLogInViewController()
        logInViewController.delegate = self
        logInViewController.fields = (PFLogInFields.UsernameAndPassword
            | PFLogInFields.LogInButton
            | PFLogInFields.SignUpButton
            | PFLogInFields.PasswordForgotten
            | PFLogInFields.DismissButton)
        
        self.presentViewController(logInViewController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
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
