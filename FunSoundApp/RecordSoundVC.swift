//
//  RecordSoundVC.swift
//  FunSoundApp
//
//  Created by Anna Kaukh on 12/23/18.
//  Copyright © 2018 Anna Kaukh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundVC: UIViewController {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func recordBtnPressed(_ sender: Any) {
        stopBtn.isEnabled = true
        recordLbl.text = "Recording..."
    }
    
    @IBAction func stopBtnPressed(_ sender: Any) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        stopBtn.isEnabled = false
    }

    func recordAudio() {
        
    }
    
}

