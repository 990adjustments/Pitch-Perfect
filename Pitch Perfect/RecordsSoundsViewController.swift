//
//  RecordsSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Santacruz on 3/9/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import AVFoundation
import UIKit


class RecordsSoundsViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioBars: UIImageView!
    
    var imageArray:[UIImage] = []
    var audioRecorder:AVAudioRecorder!
    var filePath: NSURL?
    
    @IBAction func recordAudio(sender: UIButton) {
        println("Recording in progress...")
        
        let img_on = UIImage(named: "microphone-on.pdf")
        microphoneButton.setImage(img_on, forState: .Normal)
        microphoneButton.enabled = false
        
        recordingLabel.hidden = false
        recordButton.hidden = false
        
        audioBars.hidden = false
        audioBars.startAnimating()
        
        // Start recording session
        audioRecorder.record()

    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("Stop recording.")
        
        let img_off = UIImage(named: "microphone-off.pdf")
        microphoneButton.setImage(img_off, forState: .Normal)
        microphoneButton.enabled = true

        recordingLabel.hidden = true
        recordButton.hidden = true
        
        audioBars.hidden = true
        audioBars.stopAnimating()
        
        // Stop recording session
        audioRecorder.stop()
        
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load animation sequence
        for imgFrame in 0...20 {
            var img = UIImage(named: "audioBars\(imgFrame).png")
            
            if let frame = img {
                imageArray.append(img!)
            } else {
                println("Unable to add image.")
            }
        }
        
        audioBars.animationImages = imageArray
        audioBars.animationRepeatCount = 0
        audioBars.animationDuration = 0.6
        
        prepareRecordSession()
    }
    
    func prepareRecordSession()
    {
        var fileManager = NSFileManager.defaultManager()
        //let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var dirPath: NSURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
        let dirPathString = dirPath.absoluteString
        //print(dirURL)
        
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentTime) + ".wav"
        //let pathArray = [dirPath, recordingName]
        let pathArray = [dirPathString!, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)

        //println(filePath)
        
        if let audioFilePath = filePath {
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: audioFilePath, settings: nil, error: nil)
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
        }
        else {
            println("Unable to create file path.")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        recordButton.hidden = true
        audioBars.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playSounds") {
            var vc = segue.destinationViewController as PlaySoundsViewController
            vc.audioFile = filePath
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

