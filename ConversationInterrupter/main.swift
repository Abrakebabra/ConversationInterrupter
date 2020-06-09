//
//  main.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation

let testQueue = DispatchQueue(label: "test")
let testGroup = DispatchGroup()

let a = SpeechSynth()


var run = true
testGroup.enter()

import Speech

let testSpeech = AVSpeechSynthesizer()
let u1 = AVSpeechUtterance(string: "test 1")
u1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")
let u2 = AVSpeechUtterance(string: "test 2")
u2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")


while run {
    let input = readLine()
    
    switch input {
    case "manager":
        a.checkTrigger(sentence: "manager")
        
    case "children":
        a.checkTrigger(sentence: "children")
        
    case "test":
        testQueue.async {
            testSpeech.speak(u1)
            testSpeech.speak(u2)
        }
        
        
    case "exit":
        run = false
        testGroup.leave()
        
    default:
        continue
    } // switch
}




testGroup.wait()



var run2 = true

import Speech
let dispatchQueue = DispatchQueue(label: "queue")
let speech = AVSpeechSynthesizer()
let phrase1 = AVSpeechUtterance(string: "test 1")
phrase1.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")
let phrase2 = AVSpeechUtterance(string: "test 2")
phrase2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.ava.premium")


while run2 {
    let input = readLine()
    
    switch input {
    case "test":
        
        dispatchQueue.async {
            speech.speak(phrase1)
            speech.speak(phrase2)
        }
        
    case "exit":
        run2 = false
        
    default:
        continue
    } // switch
}
