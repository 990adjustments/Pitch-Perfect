//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Santacruz on 3/12/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var playSlowButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioFile: NSURL?
    
    @IBAction func stopAudio(sender: UIButton) {
        println("Stop playing audio.")
        
        if audioPlayer.playing {
            audioPlayer.stop()
        }
    }
    
    @IBAction func PlaySlowButton(sender: UIButton) {
        println("Play slow audio.")
        
        if (audioPlayer != nil) {
            playAudioWithRate(0.5)
        } else {
            println("Cannot play audio.")
        }
    }
    
    @IBAction func PlayFastButton(sender: UIButton) {
        println("Play fast.")
        
        if (audioPlayer != nil) {
            playAudioWithRate(1.75)
        } else {
            println("Cannot play audio.")
        }
    }
    
    func playAudioWithRate(rate:Float)
    {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(audioFile)
        
        if let recordedAudio = audioFile {
            audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio, error: nil)
            audioPlayer.enableRate = true
            audioPlayer.prepareToPlay()
        }
        else {
            println("No audio file found.")
        }
        
//        let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
//        
//        if let soundFile = filePath {
//            let mp3file = NSURL(fileURLWithPath: soundFile)
//            
//            
//            audioPlayer = AVAudioPlayer(contentsOfURL: audioFile, error: nil)
//            audioPlayer.enableRate = true
//            audioPlayer.prepareToPlay()
//        } else {
//            println("Sound file not valid.")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
