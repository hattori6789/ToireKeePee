import UIKit

class ViewController: UITableViewController {
    // エントリーの配列
    var entries = NSArray()
    
    // ニュースサイトのアドレス
    let newsUrlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.itmedia.co.jp/rss/2.0/news_bursts.xml&num=8"
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // エントリーの数を返す
        return entries.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得する
        var cell = tableView.dequeueReusableCellWithIdentifier("news") as! UITableViewCell
        
        // エントリーを取得する
        var entry = entries[indexPath.row] as! NSDictionary
        
        // タイトルを設定する
        cell.textLabel?.text = entry["title"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // セグエを実行する
        performSegueWithIdentifier("detail", sender: entries[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // "detail"セグエ"の場合
        if segue.identifier == "detail" {
            // DetailControllerを取得する
            var detailController = segue.destinationViewController as! DetailController
            
            // エントリーを設定する
            detailController.entry = sender as! NSDictionary
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        // データのダウンロードを行う
        var url = NSURL(string: newsUrlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            // JSONデータを辞書に変換する
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            // /responseData/feed/entriesを取得する
            if var responseData = dict["responseData"] as? NSDictionary {
                if var feed = responseData["feed"] as? NSDictionary {
                    if var entries = feed["entries"] as? NSArray {
                        // エントリーの配列を設定する
                        self.entries = entries
                    }
                }
            }
            
            // テーブルビューの更新をするため、メインスレッドにスイッチする
            dispatch_async(dispatch_get_main_queue(), {
                // テーブルビューの更新をする
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
}

