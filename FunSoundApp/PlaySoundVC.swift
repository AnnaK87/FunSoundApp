//
//  PlaySoundVC.swift
//  FunSoundApp
//
//  Created by Anna Kaukh on 12/23/18.
//  Copyright © 2018 Anna Kaukh. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundVC: UIViewController {

    @IBOutlet weak var snailBtn: UIButton!
    @IBOutlet weak var rabbitBtn: UIButton!
    @IBOutlet weak var chipmunkBtn: UIButton!
    @IBOutlet weak var vaderBtn: UIButton!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    var recordedAudioUrl: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    @IBAction func playSound(_ sender: UIButton) {
      switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSoundWith(rate: 0.5)
        case .fast:
            playSoundWith(rate: 2.0)
        case .chipmunk:
            playSoundWith(pitch: 1000)
        case .vader:
            playSoundWith(pitch: -1000)
        case .echo:
            playSoundWith(echo: true)
        case .reverb:
            playSoundWith(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        stopAudio()
    }
    
}

    


