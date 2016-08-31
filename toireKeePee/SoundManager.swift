//
//  ViewController.swift
//  toireKeePee
//
//  Created by hattori
//  Copyright (c) 2015年 hattori. All rights reserved.
//

import Foundation
import AVFoundation


class SoundManager: NSObject {
    
    var player: AVAudioPlayer?
    
    // 音を再生するメソッド
    func sePlay(soundName: String) {
        // バンドルPathの作成
        let bndlPath = NSBundle.mainBundle().bundlePath
        // 読み込んだファイルにパスをつける
        let url = NSURL.fileURLWithPath(bndlPath).URLByAppendingPathComponent(soundName)
         // playerに読み込んだmp3ファイルへのパスを設定する
        player = try! AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        player?.volume = 0.5
        player?.prepareToPlay()
        player?.play()
    }
    
    
    // BGM再生のメソッド
    func bgmPlay(soundName: String) {
        
        // バンドルPathの作成
        let bndlPath = NSBundle.mainBundle().bundlePath
        
        // 読み込んだファイルにパスをつける
        let url = NSURL.fileURLWithPath(bndlPath).URLByAppendingPathComponent(soundName)
        
        // playerに読み込んだmp3ファイルへのパスを設定する
        player = try! AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil)
        player?.numberOfLoops = -1
        player?.volume = 0.5
        player?.prepareToPlay()
        player?.play()
    }

    
}
