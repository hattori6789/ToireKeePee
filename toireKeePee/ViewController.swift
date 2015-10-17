//
//  ViewController.swift
//  toireKeePee
//
//  Created by hattori on 2015/08/11.
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import AVFoundation
import Social


class ViewController: UIViewController {
    
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var line: UIButton!
    @IBOutlet weak var setUpLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameOverScoreLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var againButton: DesignableButton!
    @IBOutlet weak var menButton: DesignableButton!
    @IBOutlet weak var womenButton: DesignableButton!
    @IBOutlet weak var judgeContainerView: UIView!
    @IBOutlet weak var judgeImageView: UIImageView!
    @IBOutlet weak var imageValueLabel: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
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
        
        // againButtonの設定
        // springライブラリ、attributeインスペクターで対応
        // againButton.layer.cornerRadius = 10.0
        // againButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        // againButton.layer.borderWidth = 3
        
        // menButtonの設定
        // springライブラリ、attributeインスペクターで対応
        // menButton.layer.masksToBounds = true
        // menButton.layer.cornerRadius = 40.0
        // menButton.layer.borderColor = UIColor.rgb(r: 52, g: 98, b: 175, alpha: 1.0).CGColor
        // menButton.layer.borderWidth = 3
        
        // womenButtonの設定
        // springライブラリ、attributeインスペクターで対応
        // womenButton.layer.masksToBounds = true
        // womenButton.layer.cornerRadius = 40.0
        // womenButton.layer.borderColor = UIColor.rgb(r: 236, g: 151, b: 151, alpha: 1.0).CGColor
        // womenButton.layer.borderWidth = 3
        
        // judgeContainerViewを非表示にする
        judgeContainerView.hidden = true
        
        // backGroundの表示
        let backgroundImage = UIImage(named: "background.png")
        backgroundImageView.image = backgroundImage
        
        // scoreの表示
        scoreLabel.text = "SCORE: 0"
        timerLabel.textAlignment = NSTextAlignment.Left
        timerLabel.text = "Time: 停止"
        
        // randomTextの表示
        randomPersonImageView()
        
        // Twitter,　Lineが利用可能状態か確認
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
        // setUpLabel.textColor = UIColor.yellowColor()
        
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
                })
                // Timerの表示
                self.timerLabel.text = "Time: \(self.cnt)"
                self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "countDown:", userInfo: nil, repeats: true)
                
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
        
        // cntを0.1秒ずつ減らす
        cnt -= 0.1
        
        // 桁数を指定して文字列を作り、timerLabelに表示する
        let str = "Time: ".stringByAppendingFormat("%.1f",cnt)
        timerLabel.text = str
        
        // cntが0になった時の処理
        if cnt <= 0 {
            timeUp()
        }
        
    }
    
    
    
    // 正解時に呼び出される処理
    func trueAnswer() {
        
        // judgiContainerViewを表示
        judgeContainerView.hidden = false
        
        // judgeImageViewにmaru.pngを表示する
        let judgeImage = UIImage(named: "maru.png")
        
        // judgeImageViewを代入
        judgeImageView.image = judgeImage
        
        // maruサウンドを鳴らす
        soundManager.sePlay("maru.mp3")
    }
    
    // 不正解時に呼び出される処理
    func falseAnswer() {
        
        // タイマー処理の停止
        timer.invalidate()
        
        // menButtonを非表示
        menButton.hidden = true
        
        // womenButtonを非表示
        womenButton.hidden = true
        
        // judgiContainerViewを表示
        judgeContainerView.hidden = false
        
        // judgeImageViewにbatsu.pngを表示する
        let judgeImage = UIImage(named: "batsu.png")
        
        // judgeImageViewを代入
        judgeImageView.image = judgeImage
        
        // batsuサウンドを鳴らす
        soundManager.sePlay("batsu.mp3")
        
        // gameOverViewを表示
        gameOverView.hidden = false
        
        // gameOverScoreLabelにスコアを代入
        gameOverScoreLabel.text = String(score)
        
        addHighScore()
        
        resultHighScore()
        
        personImageView.image = UIImage(named: "munku.png")
        
    }
    
    func timeUp() {
        
        // gameOverViewを表示
        gameOverView.hidden = false
        
        // timerLabelを0表示する
        self.timerLabel.text = "Time: 0.0"
        
        // タイマー処理の停止
        timer.invalidate()
        
        // 終了の笛の音を鳴らす
        soundManager.sePlay("hue.mp3")
        
        // menButtonを非表示
        menButton.hidden = true
        
        // womenButtonを非表示
        womenButton.hidden = true
        
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
            highScoreLabel.text = "ハイスコア: 0"
        } else {
            if let highScore = rappedHighScore {
                highScoreLabel.text = "ハイスコア: \(highScore)"
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
    
    // ゲームオーバー画面を表示する
    func addGameOrverView() {
    }
    
    
    
    @IBAction func menButtonTapped(sender: DesignableButton) {
        // imageValueが、属性ラベルと一致していたら
        if imageValueLabel.text == "おっさん" {
            sender.animate()
            trueAnswer()
            // Scoreを更新
            addScore()
            
            
        } else {
            
            // 不正解時の処理
            falseAnswer()
            
        }
        
    }
    
    @IBAction func ladyButtonTapped(sender: AnyObject) {
        
        // imageValueが、属性ラベルと一致していたら
        if imageValueLabel.text == "ぎゃる" {
            sender.animate()
            trueAnswer()
            // Scoreを更新
            addScore()
            
        } else {
            
            // 不正解時の処理
            falseAnswer()
            
        }
    }
    
    @IBAction func judgeButtonTapped(sender: AnyObject) {
        // judgeContainerViewを非表示にする
        judgeContainerView.hidden = true
        
        // imageValueをランダムに更新する処理
        randomPersonImageView()
        
    }
    
    func share(type: String) {
        let vc = SLComposeViewController(forServiceType: type)
        vc.setInitialText("[駆け込め！トイレ運動会]スコア：\(score)点\nぎゃるとおっさんがトイレに駆け込むシンプルゲーム！\nURL:\n")
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func twitterTapped(sender: AnyObject) {
        share(SLServiceTypeTwitter)
    }
    
    @IBAction func lineTapped(sender: AnyObject) {
        let message = "[駆け込め！トイレ運動会]スコア：\(score)点\nぎゃるとおっさんがトイレに駆け込むシンプルゲーム！\nURL:\n"
        if let encoded = message.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()) {
            if let uri = NSURL(string: "line://msg/text/" + encoded) {
                UIApplication.sharedApplication().openURL(uri)
            }
        }
        
    }
    
}