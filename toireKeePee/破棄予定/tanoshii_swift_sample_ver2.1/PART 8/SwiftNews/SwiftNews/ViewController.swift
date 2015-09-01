//
//  ViewController.swift
//  SwiftNews
//
//  Created by Makoto Kinoshita on 2014/09/21.
//  Copyright (c) 2014年 HMDT CO., Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var entries: NSArray = []
    
    let newsUrlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/rss.xml&num=8"
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("news") as UITableViewCell
        
        var entry = entries[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = entry["title"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender: entries[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            var detailController = segue.destinationViewController as DetailController
            detailController.entry = sender as NSDictionary
        }
    }
    
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
            // JSONデータを辞書に変換する
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            
            // /responseData/feed/entriesを取得する
            if let responseData = dict["responseData"] as? NSDictionary {
                if let feed = responseData["feed"] as? NSDictionary {
                    if let entries = feed["entries"] as? NSArray {
                        self.entries = entries
                    }
                }
            }
            
            // メインスレッドにスイッチする
            dispatch_async(dispatch_get_main_queue(), {
                // テーブルビューを更新する
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
}

