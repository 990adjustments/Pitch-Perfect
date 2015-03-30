//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Erwin Santacruz on 3/12/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioData: RecordedAudio!
    
    let VADER: Float = -1000.0
    let CHIPMUNK: Float = 1500.0
    
    @IBAction func stopAudio(sender: UIButton) {
        println("Stop playing audio.")
        
        if (audioPlayer.playing || audioEngine.running) {
            audioEngine.stop()
            audioPlayer.stop()
            audioEngine.reset()
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
    
    @IBAction func PlayChipmunkSoundButton(sender: UIButton) {
        println("Play Chipmunk Sound.")

        if (audioPlayer != nil) {
            playAudioWithVariablePitch(CHIPMUNK)

        } else {
            println("Cannot play audio.")
        }
    }
    
    @IBAction func PlayDarthVaderSoundButton(sender: UIButton) {
        println("Play Darth Vader Sound.")
        
        if (audioPlayer != nil) {
            playAudioWithVariablePitch(VADER)
            
        } else {
            println("Cannot play audio.")
        }
    }
    
    @IBAction func PlaySoundEffectButton(sender: UIButton) {
        println("Play Echo Sound Effect.")
        
        if (audioPlayer != nil) {
            var audioEffect = AVAudioUnitDistortion()
            audioEffect.loadFactoryPreset(.MultiEcho2)
            
            //playWithSoundEffect()
            playSoundEffect(audioEffect)
            
        } else {
            println("Cannot play audio.")
        }
    }
    
    @IBAction func playCathedralEffect(sender: UIButton) {
        println("Play Cathedral Sound Effect.")

        if (audioPlayer != nil) {
            var audioEffect = AVAudioUnitReverb()
            audioEffect.wetDryMix = 50.0
            audioEffect.loadFactoryPreset(.Cathedral)
            
            //playWithSoundWithReverb()
            playSoundEffect(audioEffect)
            
        } else {
            println("Cannot play audio.")
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioFile = AVAudioFile(forReading: audioData.filePathUrl, error: nil)
        
        if (audioFile != nil) {
            var audioNode = AVAudioPlayerNode()
            audioEngine.attachNode(audioNode)
            
            var audioPitchEffect = AVAudioUnitTimePitch()
            audioPitchEffect.pitch = pitch
            audioEngine.attachNode(audioPitchEffect)
            
            audioEngine.connect(audioNode, to: audioPitchEffect, format: nil)
            audioEngine.connect(audioPitchEffect, to: audioEngine.outputNode, format: nil)
            
            audioNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
            audioEngine.startAndReturnError(nil)
            audioNode.play()
        }
    }
    
    func playSoundEffect(effect: AVAudioNode)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioFile = AVAudioFile(forReading: audioData.filePathUrl, error: nil)
        
        var audioEffectNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioEffectNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioEffectNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioEffectNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioEffectNode.play()
    }
    
    func playAudioWithRate(rate:Float)
    {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if audioData != nil {
            audioPlayer = AVAudioPlayer(contentsOfURL: audioData.filePathUrl , error: nil)
            audioPlayer.enableRate = true
            audioPlayer.prepareToPlay()
            
            audioEngine = AVAudioEngine()
        }
        else {
            println("No audio file found.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
