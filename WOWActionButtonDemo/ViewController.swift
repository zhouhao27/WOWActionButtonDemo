//
//  ViewController.swift
//  WOWActionButtonDemo
//
//  Created by Zhou Hao on 11/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginButton: WOWActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onStartLogin(sender: AnyObject) {
        
        loginButton.startAction()
        delay(2) { () -> () in
            
            self.loginButton.stopActionToReset(true)
            self.loginButton.stopActionToExpand(self.view)
        }
        
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

