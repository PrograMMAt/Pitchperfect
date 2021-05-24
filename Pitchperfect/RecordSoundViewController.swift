//
//  RecordSoundViewController.swift
//  Pitchmeperfect
//
//  Created by Ondrej Winter on 09/07/2020.
//  Copyright © 2020 Levit8. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundViewController: UIViewController {

    var audioRecorder: AVAudioRecorder!
    
    // MARK: IBoutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: CUSTOM FUNCTIONS
    func setUIState(isRecording: Bool, recordingText:String) {
            recordingLabel.text = recordingText
            stopRecordingButton.isEnabled = isRecording
            recordButton.isEnabled = !isRecording
    }
    
    
    // MARK: NATIVE VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
     }
    
    // MARK: RECORD
    @IBAction func recordAudio(_ sender: Any) {
        setUIState(isRecording: true, recordingText: "Recording in Progress")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
    
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: STOP RECORDING
    @IBAction func stopRecording(_ sender: Any) {
        setUIState(isRecording: false, recordingText: "Tap to record")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        }
    
        
    // MARK: SEGUE
    // preparing segue for sending data with it and than sending them
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


    // MARK: AVAudioRecorderDelegate
extension RecordSoundViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let alert = UIAlertController(title: "Attention", message: "Recording Failed", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
