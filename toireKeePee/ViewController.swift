//
//  ViewController.swift
//  toireKeePee
//
//  Created by hattori
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class ViewController: UIViewController {
        
    @IBOutlet weak var judgeButton: UIButton!
    @IBOutlet weak var twitter: DesignableButton!
    @IBOutlet weak var line: DesignableButton!
    @IBOutlet weak var setUpLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameOverScoreLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var retryButton: DesignableButton!
    @IBOutlet weak var menButton: DesignableButton!
    @IBOutlet weak var womenButton: DesignableButton!
    @IBOutlet weak var judgeContainerView: UIView!
    @IBOutlet weak var judgeImageView: UIImageView!
    @IBOutlet weak var imageValueLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    // タイマーの秒数の設定
    var cnt: Float = 20
    
    // タイマーの作成
    var timer: NSTimer!
    
    // scoreのデフォルト値
    var score: Int = 0
    
    // SoundManagerを実体化
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画面読み込み時はgameOverViewを非表示にする
        gameOverView.hidden = true
        
        // judgeContainerViewを非表示にする
        judgeContainerView.hidden = true
        
        // scoreの表示
        scoreLabel.text = "SCORE: 0"
        timerLabel.textAlignment = NSTextAlignment.Left
        timerLabel.text = "TIME: READY"
        
        // randomTextの表示
        randomPersonImageView()
        
        // TwitterとLineが利用可能状態か確認
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "line://")!) {
            line.enabled = true
        }
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            twitter.enabled = true
        }

        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Labelを、、、
        setUpLabel.alpha = 0
        
        // タッチイベントの状態確認と、、、
        touchEventCheck()
        
        // アニメーションの設定
        let duration = 1.0
        let delay = 1.0
        
        UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseInOut, animations: { () -> Void in
            self.setUpLabel.alpha = 1
            self.setUpLabel.text = "よーい・・・"
            }, completion: {(Bool) -> Void in
                UIView.animateWithDuration(duration, animations: {
                    () -> Void in
                    self.touchEventCheck()
                    self.setUpLabel.alpha = 0.0
                    self.setUpLabel.text = "どん！！"
                    
                    // Timerの表示
                    if self.timer == nil {
                        self.timerLabel.text = "TIME: \(self.cnt)"
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.countDown(_:)), userInfo: nil, repeats: true)
                    } else {
                        self.timer.fire()
                    }

                })
                
        })
        
        
    }
    
    // touchEventの状態の状態判定
    func touchEventCheck() {
        if UIApplication.sharedApplication().isIgnoringInteractionEvents() == false {
            
            // タッチイベントを有効にする処理
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            
            // タッチイベントを無効にする処理
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }   
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド
    func countDown(timer : NSTimer) {
        
        // 桁数を指定して文字列を作り、文字列を作成
        let str = "TIME: ".stringByAppendingFormat("%.1f",cnt)
        timerLabel.text = str
        // cntを0.1秒ずつ減らす
        cnt -= 0.1
        
        // cntが0になった時の処理
        if cnt < 0 {
            
            // タイマー処理の停止
            timer.invalidate()
            // timerLabelの表示を"TIME: 0.0"にする
            self.timerLabel.text = "TIME: 0.0"
            // timeUp処理
            timeUp()
        }
        
    }
    
    
    
    // 正解時に呼び出される処理
    func trueAnswer(trueImage: String) {
        
        // judgiContainerViewを表示
        judgeContainerView.hidden = false
        
        // judgeImageViewにmaru.pngを表示する
        let judgeImage = UIImage(named: "maru.png")

        // judgeImageViewを代入
        judgeImageView.image = judgeImage
        
        //
        personImageView.image = UIImage(named: trueImage)
        
        // maruサウンドを鳴らす
        soundManager.sePlay("maru.mp3")
        
        // 一定時間止める
        let delay = 0.2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            // imageValueをランダムに更新する処理
            self.randomPersonImageView()
            // judgeContainerViewを非表示にする
            self.judgeContainerView.hidden = true
            
        }
        
    }
    
    // 不正解時に呼び出される処理
    func falseAnswer(falseImage: String) {
        
        // タイマー処理の停止
        timer.invalidate()
        
        //judgeButtonを無効化
        judgeButton.enabled = false
        
        // menButtonを非表示
        menButton.enabled = false
        menButton.hidden = true
        
        // womenButtonを非表示
        womenButton.enabled = false
        womenButton.hidden = true
        
        // batsuサウンドを鳴らす
        soundManager.sePlay("batsu.mp3")
        
        // 一時停止後にgameOverViewを表示
        pouseGameOverView()
        
        // gameOverScoreLabelにスコアを代入
        gameOverScoreLabel.text = String(score)

        // judgeContainerViewを表示
        judgeContainerView.hidden = false
        
        let delay = 0.7 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.judgeContainerView.hidden = true

        })

        // judgeImageViewにbatsu.pngを表示する
        let judgeImage = UIImage(named: "batsu.png")

        // judgeImageViewを代入
        judgeImageView.image = judgeImage
        
        addHighScore()
        
        resultHighScore()
        
        personImageView.image = UIImage(named: falseImage)
        
    }
    
    func timeUp() {
        
        // 終了の笛の音を鳴らす
        soundManager.sePlay("hue.mp3")
        
        //judgeButtonを無効化
        judgeButton.enabled = false
        
        // menButtonを非表示
        menButton.enabled = false
        menButton.hidden = true
        
        // womenButtonを非表示
        womenButton.enabled = false
        womenButton.hidden = true
        
        // 一時停止後にgameOverViewを表示
        pouseGameOverView()
        
        // gameOverScoreLabelにスコアを代入
        gameOverScoreLabel.text = String(score)
        
        addHighScore()
        
        resultHighScore()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //　scoreを更新する関数
    func addScore() {
        score += 1
        scoreLabel.text = "SCORE: \(String(score))"
    }
    
    // highScore表示処理
    func resultHighScore(){
        let ud = NSUserDefaults.standardUserDefaults()
        let rappedHighScore = ud.objectForKey("udScore") as? Int
        if rappedHighScore == nil {
            highScoreLabel.text = "HIGH SCORE: 0"
        } else {
            if let highScore = rappedHighScore {
                highScoreLabel.text = "HIGH SCORE: \(highScore)"
            }
        }
        
    }
    
    // highScoreの更新
    func addHighScore() {
        // highScore用のUserDefaultsの実装
        let ud = NSUserDefaults.standardUserDefaults()
        let highScore = ud.objectForKey("udScore") as? Int
        if score >= highScore {
            ud.setObject(score, forKey: "udScore")
            ud.synchronize()
        }
    }
    
    
    // personImageViewをランダムに更新し、imageValueLabelを合わせて更新する関数
    func randomPersonImageView() {
        
        var randomInt: Int
        
        // 乱数を作る
        randomInt = Int(arc4random_uniform(2))
        imageValueLabel.text = ""
        
        
        if randomInt == 0 {

            // あとで消す　Button属性
            imageValueLabel.text = "おっさん"
            
            // menRight.pngを実体化
            let rightManImage = UIImage(named: "men.png")
            
            // personImageViewのimageにmenRight.pngを設定
            personImageView.image = rightManImage
            
        } else if randomInt == 1 {
            // あとで消す　Button属性
            imageValueLabel.text = "ぎゃる"
            // womenRight.pngを実体化
            let rightWomenImage = UIImage(named: "women.png")
            
            // personImageViewのimageにwomenRight.pngを設定
            personImageView.image = rightWomenImage
        } else {
            print("エラー")
        }
    }
    
    @IBAction func menButtonTapped(sender: DesignableButton) {
        // imageValueが、属性ラベルと一致していたら
        if imageValueLabel.text == "おっさん" {
            sender.animate()
            trueAnswer("menTrueAction.png")
            // Scoreを更新
            addScore()
        } else {
            // 不正解時の処理
            falseAnswer("womenFalseAction.png")
        }
        
    }
    
    func pouseGameOverView() {
        
        let delay = 0.7 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.gameOverView.hidden = false
        })

    }
    
    
    @IBAction func ladyButtonTapped(sender: DesignableButton) {
        
        // imageValueが、属性ラベルと一致していたら
        if imageValueLabel.text == "ぎゃる" {
            sender.animate()
            trueAnswer("womenTrueAction.png")
            // Scoreを更新
            addScore()
        } else {
            
            // 不正解時の処理
            falseAnswer("menFalseAction.png")
        }
    }
    
    func share(type: String) {
        let vc = SLComposeViewController(forServiceType: type)
        let text = "[駆け込め！トイレ運動会]\nスコア：\(score)点\nぎゃるとおっさんがトイレに駆け込むシンプルゲーム！\n"
        let url = "url.com"
        vc.setInitialText(text)
        vc.addURL(NSURL(string: url))
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func twitterTapped(sender: AnyObject) {
        share(SLServiceTypeTwitter)
    }
    
    @IBAction func lineTapped(sender: AnyObject) {
        let message = "[駆け込め！トイレ運動会]スコア：\(score)点\nぎゃるとおっさんがトイレに駆け込むシンプルゲーム！\nURL:XXXXX\n"
        if let encoded = message.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) {
            if let url = NSURL(string: "line://msg/text/" + encoded) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
    
    @IBAction func retryButtonTapped(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        timer.invalidate()
    }
}