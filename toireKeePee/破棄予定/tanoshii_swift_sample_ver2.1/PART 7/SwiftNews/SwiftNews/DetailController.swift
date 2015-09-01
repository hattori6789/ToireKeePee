import UIKit

class DetailController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    // エントリー
    var entry = NSDictionary()
    
    override func viewDidLoad() {
        // スーパークラスを呼び出す
        super.viewDidLoad()
        
        // WebビューでURLを読み込む
        var url = NSURL(string: self.entry["link"] as String)!
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}
