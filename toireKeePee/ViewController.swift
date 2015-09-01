//
//  ViewController.swift
//  toireKeePee
//
//  Created by hattori on 2015/08/11.
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var gameOverScoreLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var againButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var womenButton: UIButton!
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
    
    // SEManagerを実体化
    var soundManeger = SEManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        // 画面読み込み時はgameOverViewを非表示にする
        gameOverView.hidden = true
        
        // againButtonの設定
        againButton.layer.cornerRadius = 10.0
        againButton.layer.borderColor = UIColor.orangeColor().CGColor
        againButton.layer.borderWidth = 3

        
        // menButtonの設定
        menButton.layer.masksToBounds = true
        menButton.layer.cornerRadius = 45.0
        menButton.layer.borderColor = UIColor.orangeColor().CGColor
        menButton.layer.borderWidth = 4
        
        // womenButtonの設定
        womenButton.layer.masksToBounds = true
        womenButton.layer.cornerRadius = 45.0
        womenButton.layer.borderColor = UIColor.orangeColor().CGColor
        womenButton.layer.borderWidth = 4

        // judgeContainerViewを非表示にする
        judgeContainerView.hidden = true
        
        // backGroundの表示
        let backgroundImage = UIImage(named: "background.png")
        backgroundImageView.image = backgroundImage
        
        // Timerの表示
        timerLabel.text = "Time:\(cnt)"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "countDown:", userInfo: nil, repeats: true)
        
        // scoreの表示
        scoreLabel.text = "SCORE: \(String(score))"
        

        // randomTextの表示
        randomPersonImageView()
        
    }
    
    //NSTimerIntervalで指定された秒数毎に呼び出されるメソッド
    func countDown(timer : NSTimer) {
        
        // cntを0.1秒ずつ減らす
        cnt -= 0.1
        
        // 桁数を指定して文字列を作り、timerLabelに表示する
        let str = "Time:".stringByAppendingFormat("%.1f",cnt)
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
        judgeImageView.image = judgeImage
        
        soundManeger.sePlay("maru.mp3")
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
        // let judgeImage = UIImage(named: "batsu.png")
        // judgeImageViewを表示？？
        // judgeImageView.image = judgeImage
        
        
        // batsuサウンドを鳴らす
        soundManeger.sePlay("batsu.mp3")
        
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
        self.timerLabel.text = "Time:0.0"
        
        // タイマー処理の停止
        timer.invalidate()
        
        // 終了の笛の音を鳴らす
        soundManeger.sePlay("hue.mp3")
        
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
        
        var text: String
        var randomInt: Int
        
        // 乱数を作る
        randomInt = Int(arc4random_uniform(2))
        imageValueLabel.text = ""
        
        
        if randomInt == 0 {
            // あとで消す　Button属性
            imageValueLabel.text = "おっさん"
            
            // menRight.pngを実体化
            let rightManImage = UIImage(named: "oyazi.png")
            
            // personImageViewのimageにmenRight.pngを設定
            personImageView.image = rightManImage
            
        } else if randomInt == 1 {
            // あとで消す　Button属性
            imageValueLabel.text = "ぎゃる"
            // womenRight.pngを実体化
            let rightWomenImage = UIImage(named: "gal.png")
            
            // personImageViewのimageにwomenRight.pngを設定
            personImageView.image = rightWomenImage
        } else {
            println("エラー")
        }
    }
    
    // ゲームオーバー画面を表示する
    func addGameOrverView() {
    }
    
    
    
    @IBAction func manButtonTapped(sender: AnyObject) {
        
        // imageValueが、属性ラベルと一致していたら
        if imageValueLabel.text == "おっさん" {
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
   
}