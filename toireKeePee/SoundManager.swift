
import Foundation
import AVFoundation


class SoundManager: NSObject {
    
    var player: AVAudioPlayer?
    
    // 音を再生するメソッド
    func sePlay(soundName: String) {
        // サウンドファイルを読み込む
        var soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        // 読み込んだファイルにパスをつける
        let url: NSURL? = NSURL.fileURLWithPath(soundPath)
        // playerに読み込んだmp3ファイルへのパスを設定する
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        player?.prepareToPlay()
        player?.play()
    }
    
    
    // BGM再生のメソッド
    func bgmPlay(soundName: String) {
        
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

    
}
