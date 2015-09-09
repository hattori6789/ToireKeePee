//
//  StartViewController.swift
//  toireKeePee
//
//  Created by hattori on 2015/08/31.
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {
    
    // リリース前に消す　versionLabel関連
    @IBOutlet weak var versionLabel: UILabel!
    //
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    // 音楽再生の引数を定義
    var player: AVAudioPlayer?
    
    // SoundManagerクラスを実体化
    var soundManager = SoundManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// リリース前に消す　versionLabel関連 ///
        let infoDictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        var CFBundleShortVersionString = infoDictionary["CFBundleShortVersionString"]! as! String
        versionLabel.text = "Ver.\(CFBundleShortVersionString)"
        //////////////////////////////////////
        
        
        // タイトルラベルの設定
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10.0
        titleLabel.layer.borderColor = UIColor.orangeColor().CGColor
        titleLabel.layer.borderWidth = 3
        
        // スタートボタンの設定
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 10.0
        startButton.layer.borderColor = UIColor.orangeColor().CGColor
        startButton.layer.borderWidth = 3

        
        // BGMの再生
        soundManager.bgmPlay("BGM.mp3")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
