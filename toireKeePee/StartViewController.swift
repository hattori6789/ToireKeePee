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
    
    
    // リリース前に消す？　versionLabel関連
    @IBOutlet weak var versionLabel: UILabel!
    ///////////////////////////////////
    
    @IBOutlet weak var startButton: DesignableButton!
    
    // 音楽再生の引数を定義
    var player: AVAudioPlayer?
    
    // SoundManagerクラスを実体化
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// リリース前に消す？　versionLabel関連 ///
        let infoDictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        let CFBundleShortVersionString = infoDictionary["CFBundleShortVersionString"]! as! String
        versionLabel.text = "Ver.\(CFBundleShortVersionString)"
        //////////////////////////////////////
        
        // スタートボタンの設定
        // springライブラリ、attributeインスペクターで対応
        // startButton.layer.masksToBounds = true
        // startButton.layer.cornerRadius = 10.0
        // startButton.layer.borderWidth = 3
        
        // BGMの再生
        soundManager.bgmPlay("BGM.mp3")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonTapped(sender: DesignableButton) {
        sender.animate()
    }
    
}
