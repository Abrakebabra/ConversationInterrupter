//
//  main.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation

let testQueue = DispatchQueue(label: "test")
let testQueue2 = DispatchQueue(label: "test2")

let a = SpeechSynth()


var run = true

import Speech



class TestSpeech: AVSpeechSynthesizer, AVSpeechSynthesizerDelegate {
    let speaker = self
    
    override init() {
        
        super.init()
        delegate = self
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("paused!")
    }
    
}

let testSpeech = TestSpeech()

let u1 = AVSpeechUtterance(string: "test 1")
u1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")
let u2 = AVSpeechUtterance(string: "test 2")
u2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")




let group2 = DispatchGroup()

testQueue2.async {
    print("test 2 queue entered")
    while run {
        print("input loop restarted")
        let input = readLine()
        
        switch input {
        case "manager":
            
            group2.enter()
            
            a.speakComplete = {
                group2.leave()
            }
            
            a.checkTrigger(sentence: "manager")
            
            group2.wait()
            
        case "children":
            a.checkTrigger(sentence: "children")
             
        case "test":
            testQueue.async {
                testSpeech.speak(u1)
                testSpeech.speak(u2)
                print("test queue end of closure")
            }
            print("testqueue finished")
             
             
        case "exit":
            run = false
            exit(EXIT_SUCCESS)
        
        default:
            continue
        } // switch
    }
}





RunLoop.main.run()


