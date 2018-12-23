//
//  PlaySoundVC.swift
//  FunSoundApp
//
//  Created by Anna Kaukh on 12/23/18.
//  Copyright © 2018 Anna Kaukh. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundVC: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var snailBtn: UIButton!
    @IBOutlet weak var rabbitBtn: UIButton!
    @IBOutlet weak var chipmunkBtn: UIButton!
    @IBOutlet weak var vaderBtn: UIButton!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var reverbBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    var recordedAudioUrl: URL!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func playSound(_ sender: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudioUrl!)
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    
    @IBAction func stopBtnPressed(_ sender: Any) {
    }
    
}
