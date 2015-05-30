//
//  ViewController.swift
//  Phonetics
//
//  Created by 颜超 on 15/5/23.
//  Copyright (c) 2015年 颜超. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    var audioPlayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        playVoice("bgmusic")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //播放声音
    func playVoice(fileName : String){
        let musicPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "mp3")
        //指定音乐路径
        let url = NSURL(fileURLWithPath: musicPath!)
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        audioPlayer.numberOfLoops = -1
        //设置音乐播放次数，-1为循环播放
        audioPlayer.volume = 1
        //设置音乐音量，可用范围为0~1
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }


}

