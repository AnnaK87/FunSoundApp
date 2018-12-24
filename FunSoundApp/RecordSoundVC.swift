//
//  RecordSoundVC.swift
//  FunSoundApp
//
//  Created by Anna Kaukh on 12/23/18.
//  Copyright © 2018 Anna Kaukh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var timerMeter: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI(false)
    }

    @IBAction func recordBtnPressed(_ sender: Any) {
       recordAudio()
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        stopRecording()
    }

    // MARK: Recording Audio
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = path[0]
        return directory
    }
    
    func getFileUrl() -> URL {
        let fileName = "recordedVoice.wav"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        print("FILEPATH: \(filePath)")
        return filePath
    }
    
    func setupRecorder() {
        let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                try session.setActive(true)
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            } catch let error {
                print(error.localizedDescription)
            }
    }
    
    func recordAudio() {
        configureUI(true)
        setupRecorder()
        audioRecorder.record()
        timerMeter = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
        
    }
    
    func stopRecording() {
        configureUI(false)
        audioRecorder.stop()
        audioRecorder = nil
        timerMeter.invalidate()
        print("Recorded successfully")
    }
    
    // MARK: Update UI
    
    func configureUI(_ enabled: Bool) {
        stopBtn.isEnabled = enabled
        recordBtn.isEnabled = !enabled
        recordLbl.text = enabled ? "Recording..." : "Tap to Record"
        if !enabled {
            timerLbl.text = "00:00:00"
        }
    }
    
    // MARK: Passing Audiofile to PlaySoundVC
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "segueToPlaySoundVC", sender: getFileUrl().absoluteURL)
        } else {
            print("Recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPlaySoundVC" {
            let playSoundVC = segue.destination as! PlaySoundVC
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioUrl = recordedAudioURL
        }
    }
   
    // MARK: Meter handling
    
    @objc func updateAudioMeter(timer: Timer) {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            timerLbl.text = totalTimeString
            audioRecorder.updateMeters()
    }
}

