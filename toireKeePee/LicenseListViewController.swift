//
//  LicenseListViewController.swift
//  toireKeePee
//
//  Created by nk on 2015/11/29.
//  Copyright © 2015年 hattori. All rights reserved.
//

import UIKit


class LicenseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private struct Software {
        var name: String
        var license: String
    }
    
    private var softwares = [Software]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainBundle = NSBundle.mainBundle()
        if let path = mainBundle.pathForResource("Licenses", ofType: "plist") {
            if let items = NSArray(contentsOfFile: path) {
                for item in items {
                    let name = item["Name"] as? String
                    let license = item["License"] as? String
                    if name == nil || license == nil { continue }
                    
                    // software配列に追加する
                    softwares.append(Software(name: name!, license: license!))
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // セルの選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Segueを実行する
        performSegueWithIdentifier("PushLicenseDetail", sender: indexPath)
    }
    
    // MARK: - UITableViewDasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Software") {
            cell.textLabel?.text = softwares[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return softwares.count
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushLicenseDetail" {
            let vc = segue.destinationViewController as! LicenseDetailViewController
            if let indexPath = sender as? NSIndexPath {
                vc.name = softwares[indexPath.row].name
                vc.license = softwares[indexPath.row].license
            }
        }
    }
}