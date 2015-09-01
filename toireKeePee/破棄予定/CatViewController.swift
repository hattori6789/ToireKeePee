//
//  DogViewController.swift
//  DogViewer3000
//
//  Created by hattori on 2015/07/01.
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import Alamofire

let accessToken = "2110574298.538deeb.4b992ae7357c4c818630f3b96a55011b"

class CatViewController: UIViewController {

    var results:[JSON]? = []
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCats()
    }
    
    func loadCats() {
        var url = "https://api.instagram.com/v1/tags/ネコ/media/recent?client_id=538deeb2495e4b0586d52b5a1bd1ab77"
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        request(.GET, url, parameters: nil, encoding: .JSON)
        Alamofire.request(.GET, url).responseJSON { (request, response, json, error) in
            if (json != nil) {
                var jsonObj = JSON(json!)
                if let data = jsonObj["data"].arrayValue as [JSON]? {
                    self.results = data
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("catCell") as! CatTableViewCell
        cell.cat = self.results?[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation

}
