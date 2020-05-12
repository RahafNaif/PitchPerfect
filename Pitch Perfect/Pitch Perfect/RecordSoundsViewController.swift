//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rahaf Naif on 05/09/1441 AH.
//  Copyright © 1441 Rahaf Naif. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{

    @IBOutlet weak var recordLable: UILabel!
    @IBOutlet weak var recButton: UIButton!
    @IBOutlet weak var stopRecButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(false)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    //MARK :RecordAudio -> func for record button action
    @IBAction func RecordAudio(_ sender: Any) {
       
        configureUI(true)
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //MARK : stopRecording -> for stop rec button action
    @IBAction func stopRecording(_ sender: Any) {
        
        configureUI(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
   
    
    func audioRecorderDidFinishRecording(_ recorded:AVAudioRecorder,successfully flag:Bool){
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("recording wasn't succssuful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"{
            let playSoundsVS = segue.destination as!PlaySoundsViewController
            let recordedAudioURL = sender as!URL
            playSoundsVS.recordedAudioURL = recordedAudioURL
        }

    }
    
    func configureUI(_ isRecording:Bool){
        
        stopRecButton.isEnabled = isRecording
        recButton.isEnabled = !isRecording
        recordLable.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
    }
    
}

