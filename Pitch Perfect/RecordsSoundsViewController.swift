//
//  RecordsSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Santacruz on 3/9/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import AVFoundation
import UIKit


class RecordsSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var audioBars: UIImageView!
    @IBOutlet weak var helperLabel: UILabel!
    
    var imageArray:[UIImage] = []
    var audioRecorder:AVAudioRecorder!
    var filePath: NSURL?
    var recordedAudio: RecordedAudio!
    
    @IBAction func recordAudio(sender: UIButton) {
        println("Recording in progress...")
        
        let img_on = UIImage(named: "microphone-on.pdf")
        microphoneButton.setImage(img_on, forState: .Normal)
        microphoneButton.enabled = false
        
        //recordingLabel.hidden = false
        //stopRecordingButton.hidden = false
        
        audioBars.hidden = false
        audioBars.startAnimating()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.helperLabel.alpha = 0
            self.stopRecordingButton.alpha = 1.0
            self.recordingLabel.alpha = 1.0
        })
        
        // Start recording session
        audioRecorder.record()

    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("Recording stopped.")
        
        let img_off = UIImage(named: "microphone-off.pdf")
        microphoneButton.setImage(img_off, forState: .Normal)
        microphoneButton.enabled = true

        //recordingLabel.hidden = true
        //stopRecordingButton.hidden = true
        
        audioBars.hidden = true
        audioBars.stopAnimating()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.helperLabel.alpha = 1.0
            self.stopRecordingButton.alpha = 0
            self.recordingLabel.alpha = 0
        })
        
        // Stop recording session
        audioRecorder.stop()
        
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load animation sequence
        for imgFrame in 0...42 {
            var img = UIImage(named: "radioWaves\(imgFrame).png")
            
            if let frame = img {
                imageArray.append(img!)
            } else {
                println("Unable to add image.")
            }
        }
        
        audioBars.animationImages = imageArray
        audioBars.animationRepeatCount = 0
        audioBars.animationDuration = 1.0
        
        stopRecordingButton.alpha = 0
        recordingLabel.alpha = 0
        helperLabel.alpha = 1.0
        audioBars.hidden = true
        
        prepareRecordSession()
    }
    
    func prepareRecordSession()
    {
        var fileManager = NSFileManager.defaultManager()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //var dirPath: NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        //let dirURL = dirPath.absoluteString
        //print(dirURL)
        
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        //let pathArray = [dir2Path, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)

        //println(filePath)
        
        if let audioFilePath = filePath {
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: audioFilePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        else {
            println("Unable to create file path.")
            stopRecordingButton.alpha = 0
            recordingLabel.alpha = 0
            helperLabel.alpha = 1.0
            audioBars.hidden = true
            audioBars.stopAnimating()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        stopRecordingButton.alpha = 0
        recordingLabel.alpha = 0
        helperLabel.alpha = 1.0
        audioBars.hidden = true
        
        //stopRecordingButton.hidden = true
        //helperLabel.hidden = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //recordedAudio.filePathUrl = recorder.url
            //recordedAudio.title = recorder.url.lastPathComponent
            
            performSegueWithIdentifier("playSounds", sender: recordedAudio)
        }
        else {
            println("Audio did not finish recording.")
            
        }
        
//        if (flag) {
//            println("Audio recording complete.")
//            performSegueWithIdentifier("playSounds", sender: self)
//        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Prepare for segue")
        if (segue.identifier == "playSounds") {
            var vc: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            
            let data = sender as RecordedAudio
            vc.audioData = data
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

