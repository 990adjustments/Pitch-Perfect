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
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    
    var imageArray:[UIImage] = []
    var audioRecorder:AVAudioRecorder!
    var filePath: NSURL?
    var recordedAudio: RecordedAudio!
    var paused: Bool = false

    
    @IBAction func recordAudio(sender: UIButton) {
        println("Recording in progress...")
        
        let img_on = UIImage(named: "microphone-on.pdf")
        swapImage(img_on!, on: false)
        
        pauseRecordingButton.enabled = true
        audioBars.hidden = false
        audioBars.startAnimating()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.helperLabel.alpha = 0
            self.stopRecordingButton.alpha = 1.0
            self.pauseRecordingButton.alpha = 1.0
            self.recordingLabel.alpha = 1.0
            
            if (self.paused) {
                self.pauseLabel.alpha = 0
            }
        })

        // Start recording session
        audioRecorder.record()
        
        paused = false

    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        println("Recording paused.")
        
        // Deal multiple pause button touches
        if (!pauseRecordingButton.enabled) {
            return
        }
        
        let img_off = UIImage(named: "microphone-off.pdf")
        swapImage(img_off!, on: true)

        audioBars.hidden = true
        audioBars.stopAnimating()
        paused = true
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.pauseLabel.alpha = 1.0
            self.recordingLabel.alpha = 0
        })
        
        // Stop recording session
        audioRecorder.pause()
        
        pauseRecordingButton.enabled = false
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("Recording stopped.")
        
        let img_off = UIImage(named: "microphone-off.pdf")
        swapImage(img_off!, on: true)
        
        audioBars.hidden = true
        audioBars.stopAnimating()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.helperLabel.alpha = 1.0
            self.stopRecordingButton.alpha = 0
            self.pauseRecordingButton.alpha = 0
            self.recordingLabel.alpha = 0
        })
        
        // Stop recording session
        audioRecorder.stop()
        
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func swapImage(img: UIImage, on: Bool) {
        self.microphoneButton.setImage(img, forState: .Normal)
        self.microphoneButton.enabled = on
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigation Bar attributes
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 1.0, green: 35.0/255.0, blue: 70.0/255.0, alpha: 1.0), NSFontAttributeName : UIFont.systemFontOfSize(20)]
        
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
        pauseRecordingButton.alpha = 0
        recordingLabel.alpha = 0
        pauseLabel.alpha = 0
        helperLabel.alpha = 1.0
        audioBars.hidden = true
        
        prepareRecordSession()
    }
    
    func prepareRecordSession()
    {
        // Set up path and name of audio file.
        var fileManager = NSFileManager.defaultManager()
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        
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
        pauseRecordingButton.alpha = 0
        pauseLabel.alpha = 0
        recordingLabel.alpha = 0
        helperLabel.alpha = 1.0
        audioBars.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("playSounds", sender: recordedAudio)
        }
        else {
            println("Audio did not finish recording.")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Send data to PlaySoundsViewController
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

