//
//  ViewController.swift
//  SwiftNews
//
//  Created by Makoto Kinoshita on 2014/09/21.
//  Copyright (c) 2014年 HMDT CO., Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("news") as! UITableViewCell
        
        cell.textLabel?.text = "Swift News"
        
        return cell
    }
}
