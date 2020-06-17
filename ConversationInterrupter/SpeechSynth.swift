//
//  karen.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation
import Speech



// MARK: Enum Voices
enum Voices {
    /// American female - very good
    case allison
    /// American female - excellent
    case ava
    /// Russian female - good
    case katya
    /// Japanese female - ok-ish
    case kyoko
    /// Japanese male - excellent
    case otoya
    /// American female - good
    case samantha
    /// British female - good
    case serena
    /// American female - good
    case susan
    /// American male - excellent
    case tom
    /// Russian male - excellent
    case yuri
    
    
    // MARK: func voiceObj
    func voiceObj() -> AVSpeechSynthesisVoice? {
        switch self {
        case .allison:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.allison.premium")
        case .ava:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.ava.premium")
        case .katya:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.katya.premium")
        case .kyoko:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.kyoko.premium")
        case .otoya:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.otoya.premium")
        case .samantha:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.samantha.premium")
        case .serena:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.serena.premium")
        case .susan:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.susan.premium")
        case .tom:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.tom.premium")
        case .yuri:
            return AVSpeechSynthesisVoice(identifier:
                "com.apple.speech.synthesis.voice.yuri.premium")
        } // switch
    }
} // enum


// MARK: Struct DialoguePortion
struct DialoguePortion {
    let content: String                     // words
    let voice: AVSpeechSynthesisVoice?      // voice to use
    let rate: Float                         // rate (Speech rates are values in the range between AVSpeechUtteranceMinimumSpeechRate and AVSpeechUtteranceMaximumSpeechRate. Lower values correspond to slower speech, and vice versa. The default value is AVSpeechUtteranceDefaultSpeechRate.)
    let volume: Float
    let pitch: Float                        // pitchMultiplier
    let postUtteranceDelay: TimeInterval    // milliseconds
    let preUtteranceDelay: TimeInterval     // milliseconds
    
    
    // MARK: init
    /// rate: 0.x-0.89,  volume: 0.x-1.0,  pitch 0.1-10.0? (once pitch is set, cannot be changed?)  delays: milliseconds
    init(content: String, voice: Voices,
         rate: Float = AVSpeechUtteranceDefaultSpeechRate, volume: Float = 1.0, pitch: Float = 1.0, postDelay: TimeInterval = 0.0, preDelay: TimeInterval = 0.0) {
        
        // find out defaults and min/max ranges, and make a checker
        self.content = content
        self.pitch = pitch
        self.postUtteranceDelay = postDelay
        self.preUtteranceDelay = preDelay
        self.rate = rate
        self.voice = voice.voiceObj()
        self.volume = volume
        
    }
}



// MARK: Struct Dialogue
struct Dialogue {
    let trigger: String
    let dialogue: [DialoguePortion]
    
    init(trigger: String, dialogue: [DialoguePortion]) {
        self.trigger = trigger
        self.dialogue = dialogue
    }
}



// MARK: Dialogues
var dialogues: [Dialogue] = [
    Dialogue(trigger: "manager", dialogue: [
        DialoguePortion(content: "The manager?  The manager!  I want to see the manager!", voice: .samantha, rate: 0.35),
        DialoguePortion(content: "I bought these at full price 2 weeks ago but I have 3 children to feed from my one hundred and twenty thousand dollar income.  How the hell is a working mother supposed to live these days.  Your staff never asked me about any coupons.  I've had this coupon since August and it gives me 5% off.", voice: .samantha, rate: 0.35),
        DialoguePortion(content: "I want a full refund.", voice: .samantha, rate: 0.35),
        DialoguePortion(content: "Eye. Don't. Care if the toothpaste is half-empty.", voice: .samantha, rate: 0.3)
    ]),
    Dialogue(trigger: "children", dialogue: [
        DialoguePortion(content: "Children?", voice: .samantha, rate: 0.3),
        DialoguePortion(content: "My children?", voice: .samantha, rate: 0.3),
        DialoguePortion(content: "Well.", voice: .samantha, rate: 0.25),
        DialoguePortion(content: "I have three lovely children.", voice: .samantha, rate: 0.3),
        DialoguePortion(content: "My eldest son is the captain of the soccer team.  My youngest son is taking piano lessons and just got a college scholarship, he's also 8 by the way, and my daughter is taking jazz dance lessons but her teacher says perhaps she would be better suited to something with class, like ballet.  She's also top of her class in every subject, but that's normal these days.  I don't know how the school district is able to support her because how is she supposed to grow when there's no room left in the education system.", voice: .samantha, rate: 0.45)
    ])
]








// MARK: Class SpeechSynth
class SpeechSynth: AVSpeechSynthesizer {
    
    private let synth = self
    private let dispatchQueue: DispatchQueue
    private let dispatchGroup: DispatchGroup
    private var dialogue: [DialoguePortion]
    private var pauseTrigger = false
    var speakStarted: (() -> ())
    var speakComplete: (() -> ())
    
    
    // MARK: init
    override init() {
        dispatchQueue = DispatchQueue(label: "synth queue")
        dispatchGroup = DispatchGroup()
        dialogue = []
        speakStarted = {
            print("spek started!")
        }
        speakComplete = {
            print("spek finished!")
            
        }
        super.init()
        delegate = self     // inherited in extension
    }
    
    
    // MARK: func speakDialogue
    private func speakDialogue() {
        self.speakStarted()
        
        // new thread
        self.dispatchQueue.async {
            for portion in self.dialogue {
                self.dispatchGroup.enter()
                let utterance = AVSpeechUtterance(string: portion.content)
                utterance.voice = portion.voice
                utterance.rate = portion.rate
                utterance.pitchMultiplier = portion.pitch
                utterance.preUtteranceDelay = portion.preUtteranceDelay
                utterance.postUtteranceDelay = portion.postUtteranceDelay
                self.speak(utterance)
            }
            
            self.dispatchGroup.wait()
            self.speakComplete()
        } // dispatchQueue
        
    } // SpeechSynth.speakDialogue
    
    
    // MARK: func loadNPlay
    private func loadNPlay(dialogue: [DialoguePortion]) {
        self.dialogue = dialogue
        speakDialogue()
    } // SpeechSynth.loadNPlay
    
    
    // MARK: func checkTrigger
    func checkTrigger(sentence: String) {
        if self.pauseTrigger == true {
            return
        }
        
        for rant in dialogues {
            if sentence.lowercased().contains(rant.trigger.lowercased()) {
                self.pauseTrigger = true
                loadNPlay(dialogue: rant.dialogue)
                break
            } // if
        } // loop
    } // SpeechSynth.checkTrigger
    
} // class SpeechSynth


// MARK: extension SpeechSynth
extension SpeechSynth: AVSpeechSynthesizerDelegate {
    
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.pauseTrigger = false
        dispatchGroup.leave()
    }
    
}

