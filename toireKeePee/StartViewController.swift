//
//  StartViewController.swift
//  toireKeePee
//
//  Created by hattori
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import UIKit
import AVFoundation

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: DesignableImageView!
    @IBOutlet weak var startButton: DesignableButton!
    
    // 音楽再生の引数を定義
    var player: AVAudioPlayer?
    
    // SoundManagerクラスを実体化
    var soundManager = SoundManager()
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animationのスタート
        titleLogoAnimation()
        
        // BGMの再生
        soundManager.bgmPlay("BGM.mp3")
        
    }
    
    func titleLogoAnimation() {
        // logo.pngのアニメーション
        logoImageView.delay = 2.0
        logoImageView.duration = 1.0
        logoImageView.animation = "fadeInDown"
        logoImageView.animateNext { () -> () in
            self.logoImageView.animation = "pop"
            self.logoImageView.animate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    
}