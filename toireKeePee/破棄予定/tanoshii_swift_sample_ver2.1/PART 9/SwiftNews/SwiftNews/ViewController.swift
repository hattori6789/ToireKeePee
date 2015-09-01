import UIKit

class ViewController: UITableViewController {
    // エントリーの配列
    var entries = NSMutableArray()
    
    // ニュースサイトの配列を作る
    let newsUrlStrings = [
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.rssad.jp/rss/impresswatch/pcwatch.rdf&num=8", 
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.itmedia.co.jp/rss/2.0/news_bursts.xml&num=8", 
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://jp.techcrunch.com/feed/&num=8", 
    ]
    
    // 画像ファイル名の配列を作る
    let imageNames = [
        "pcwatch", 
        "itmedia", 
        "techcrunch", 
    ]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // エントリーの数を返す
        return entries.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得する
        var cell: UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("top") as UITableViewCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("news") as UITableViewCell
        }
        
        // エントリーを取得する
        var entry = entries[indexPath.row] as NSDictionary
        
        // タイトルラベルを取得して、タイトルを設定する
        var titleLabel = cell.viewWithTag(1) as UILabel
        titleLabel.text = entry["title"] as? String
        
        // 本文ラベルを取得して、本文を設定する
        var descriptionLabel = cell.viewWithTag(2) as UILabel
        descriptionLabel.text = entry["contentSnippet"] as? String
        
        // NSDateFormatterを作って、日付を文字列に変換する
        var date = entry["date"] as NSDate
        var formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja-JP")
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        var dateStr = formatter.stringFromDate(date)
        
        // 日付ラベルを取得して、日付を設定する
        var dateLabel = cell.viewWithTag(3) as UILabel
        dateLabel.text = dateStr
        
        // 画像ファイル名を決定して、UIImageを作る
        var urlString = entry["url"] as String
        var index = find(newsUrlStrings, urlString)
        var imageName = imageNames[index!]
        var image = UIImage(named: imageName)
        
        // イメージビューを取得して、画像を設定する
        var imageView = cell.viewWithTag(4) as UIImageView
        imageView.image = image
        
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

    @IBAction func refresh(sender: AnyObject) {
        // エントリーを全て削除する
        entries.removeAllObjects()
        
        // ニュースサイトの配列からアドレスを取り出す
        for newsUrlString in newsUrlStrings {
            // データのダウンロードを行う
            var url = NSURL(string: newsUrlString)!
            var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in 
                // JSONデータを辞書に変換する
                var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                // /responseData/feed/entriesを取得する
                if var responseData = dict["responseData"] as? NSDictionary {
                    if var feed = responseData["feed"] as? NSDictionary {
                        if var entries = feed["entries"] as? NSArray {
                            // NSDateFormatterのインスタンスを作る
                            var formatter = NSDateFormatter()
                            formatter.locale = NSLocale(localeIdentifier: "en-US")
                            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzzz"
                            
                            // エントリーに情報を追加する
                            for var i = 0; i < entries.count; i++ {
                                // エントリーを取り出す
                                var entry = entries[i] as NSMutableDictionary
                                
                                // ニュースサイトのURLを追加する
                                entry["url"] = newsUrlString
                                
                                // NSDate型の日付を追加する
                                var dateStr = entry["publishedDate"] as String
                                var date = formatter.dateFromString(dateStr)
                                entry["date"] = date
                            }
                            
                            // エントリーを配列に追加する
                            self.entries.addObjectsFromArray(entries)
                            
                            // エントリーをソートする
                            self.entries.sortUsingComparator({ object1, object2 in 
                                // 日付を取得する
                                var date1 = object1["date"] as NSDate
                                var date2 = object2["date"] as NSDate
                                
                                // 日付を比較する
                                var order = date1.compare(date2)
                                
                                // 比較結果をひっくり返す
                                if order == NSComparisonResult.OrderedAscending {
                                    return NSComparisonResult.OrderedDescending
                                }
                                else if order == NSComparisonResult.OrderedDescending {
                                    return NSComparisonResult.OrderedAscending
                                }
                                return order
                            })
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
}

