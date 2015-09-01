//
//  ViewController.swift
//  SwiftNews
//
//  Created by Makoto Kinoshita on 2014/09/21.
//  Copyright (c) 2014年 HMDT CO., Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let newsUrlString = "http://www.apple.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refresh(sender: AnyObject) {
        let url = NSURL(string: newsUrlString)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in 
            println("done, length \(data.length)")
        })
        task.resume()
    }
}

