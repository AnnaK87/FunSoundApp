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
    
    var audioRecorder: AVAudioRecorder!
    var isAudioRecordingGranted: Bool!
    var timerMeter: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRecordPermission()
    }

    @IBAction func recordBtnPressed(_ sender: Any) {
       recordAudio()
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        stopRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        stopBtn.isEnabled = false
    }

    func recordAudio() {
        recordBtn.isEnabled = false
        stopBtn.isEnabled = true
        recordLbl.text = "Recording..."
        
        setupRecorder()
        audioRecorder.record()
        timerMeter = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
    }
    
    func stopRecording() {
        stopBtn.isEnabled = false
        recordBtn.isEnabled = true
        recordLbl.text = "Tap to Record"
        
        audioRecorder.stop()
        audioRecorder = nil
        timerMeter.invalidate()
        print("recorded successfully")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "segueToPlaySoundVC", sender: audioRecorder.url)
        } else {
            print("Recording failed")
        }
    }
    
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({(allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = path[0]
        print(directory)
        return directory
        
    }
    
    func getFileUrl() -> URL {
        let fileName = "recordedVoice.wav"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        return filePath
    }
    
    func setupRecorder() {
        if isAudioRecordingGranted {
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
        else {
            print("No access to microphone")
            recordLbl.text = "No access to microphone"
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //recordingTimeLabel.text = totalTimeString
            print(totalTimeString)
            audioRecorder.updateMeters()
    }
}

