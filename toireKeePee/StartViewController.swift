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
    
    @IBOutlet weak var logoImageView: DesignableImageView!
    @IBOutlet weak var startButton: DesignableButton!
    
    // 音楽再生の引数を定義
    var player: AVAudioPlayer?
    
    // SoundManagerクラスを実体化
    var soundManager = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animationのスタート
        titleLogoAnimation()
        
        // BGMの再生
        soundManager.bgmPlay("BGM.mp3")
        
        /// リリース前に消す？　versionLabel関連 ///
        let infoDictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        let CFBundleShortVersionString = infoDictionary["CFBundleShortVersionString"]! as! String
        versionLabel.text = "Ver.\(CFBundleShortVersionString)"
    }
    
    func titleLogoAnimation() {
        // logo.pngのアニメーション
        logoImageView.delay = 2.2
        logoImageView.duration = 1.0
        logoImageView.animation = "fadeInDown"
        logoImageView.animateNext { () -> () in
            self.logoImageView.animation = "pop"
            self.logoImageView.animate()
        }
    }
    
    // 時点での時間を表示
    func printTime(name: String) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH時mm分ss.SSS秒"
        let string = formatter.stringFromDate(now)
        print(string + " \(name)が呼ばれた")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}