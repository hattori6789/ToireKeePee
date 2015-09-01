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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // 音楽を鳴らす
    var player: AVAudioPlayer?
    var soundManeger = SEManager()
    
    // BGM再生のメソッド
    func play(soundName: String) {

        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10.0
        titleLabel.layer.borderColor = UIColor.orangeColor().CGColor
        titleLabel.layer.borderWidth = 3

        
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 10.0
        startButton.layer.borderColor = UIColor.orangeColor().CGColor
        startButton.layer.borderWidth = 3

        
        // String型の引数からサウンドファイルを読み込む
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        // 読み込んだファイルにパスをつける
        let url: NSURL? = NSURL.fileURLWithPath(soundPath)
        // playerに読み込んだmp3ファイルへのパスを設定する
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player?.numberOfLoops = -1
        player?.prepareToPlay()
        player?.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BGMの再生
        play("BGM.mp3")
        


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
