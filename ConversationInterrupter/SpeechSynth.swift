//
//  karen.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation
import Speech

let triggerAndBlab: [[String]] = [
["manager", "The manager?  I want to see the manager!  I bought these at full price 2 weeks ago but I have 3 children to feed from my $120,000 income.  How the hell is a working mother supposed to live these days.  Your staff never asked me about any coupons.  I've had this coupon since August and it gives me 5% off.  I want a full refund.  I don't care if the toothpaste is half-empty."],
["children", "My children?  Well I have 3 lovely children.  My eldest son is the captain of the soccer team, my youngest son is taking piano lessons and just got a college scholarship, he's also 8 by the way, and my daughter is taking jazz dance lessons but her teacher says perhaps she would be better suited to something with class like ballet.  She's also top of her class in every subject but that's normal these days.  I don't know how the school district is able to support her because how is she supposed to grow when there's no room left in the education system?"]
    ]






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
    
    func string() -> String {
        switch self {
        case .allison:
            return "com.apple.speech.synthesis.voice.allison.premium"
        case .ava:
            return "com.apple.speech.synthesis.voice.ava.premium"
        case .katya:
            return "com.apple.speech.synthesis.voice.katya.premium"
        case .kyoko:
            return "com.apple.speech.synthesis.voice.kyoko.premium"
        case .otoya:
            return "com.apple.speech.synthesis.voice.otoya.premium"
        case .samantha:
            return "com.apple.speech.synthesis.voice.samantha.premium"
        case .serena:
            return "com.apple.speech.synthesis.voice.serena.premium"
        case .susan:
            return "com.apple.speech.synthesis.voice.susan.premium"
        case .tom:
            return "com.apple.speech.synthesis.voice.tom.premium"
        case .yuri:
            return "com.apple.speech.synthesis.voice.yuri.premium"
        } // switch
    } // string
} // enum


struct DialoguePortion {
    let content: String                     // words
    let pitchMultiplier: Float              // pitchMultiplier
    let postUtteranceDelay: TimeInterval    // milliseconds
    let preUtteranceDelay: TimeInterval     // milliseconds
    let rate: Float                         // rate (Speech rates are values in the range between AVSpeechUtteranceMinimumSpeechRate and AVSpeechUtteranceMaximumSpeechRate. Lower values correspond to slower speech, and vice versa. The default value is AVSpeechUtteranceDefaultSpeechRate.)
    let voice: String                       // voice to use
    let volume: Float
    
    init(content: String, voice: Voices,
         _ pitch: Float = 1.0, _ postDelay: TimeInterval = 0.0, _ preDelay: TimeInterval = 0.0, _ rate: Float = AVSpeechUtteranceDefaultSpeechRate, _ volume: Float = 1.0) {
        
        self.content = content
        self.pitchMultiplier = pitch
        self.postUtteranceDelay = postDelay
        self.preUtteranceDelay = preDelay
        self.rate = rate
        self.voice = voice.string()
        self.volume = volume
        
    }
}


class SpeechSynth: AVSpeechSynthesizer {
    
    let synth = self
    
    // ["voice" : "String", "rate" : "Int", "content" : "String", ]
    var dialogueCurrent: DialoguePortion = DialoguePortion(content: "initializing...", voice: Voices.yuri)
    var dialogueQueue: [DialoguePortion] = []
    
    var speakStarted: (() -> ()) = {}
    var phraseComplete: (() -> ()) = {}
    var speakComplete: (() -> ()) = {}
    
    override init() {
        super.init()
        delegate = self
    }
    
    

    
    private func speakSegment() {
        
        
        //guard let rate = dialogueCurrent[1]["rate"] as! Float else
        
        //let rate = dialogueCurrent[1]["rate"]
        //self.speak(<#T##utterance: AVSpeechUtterance##AVSpeechUtterance#>)
    }
    
    func loadNPlay(dialogue: [[String : Any]]) {
        dialogueQueue = dialogue
        dialogueCurrent = dialogueQueue[0]
        dialogueQueue.remove(at: 0)
    }
}

extension SpeechSynth: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speakStarted()
        print("spek started!")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakComplete()
        print("spek finished!")
    }
}


class Karen2: SpeechSynth {
    
    override init() {
        super.init()
    }
    
    func say(words: AVSpeechUtterance, voice: AVSpeechSynthesisVoice) {
        let utterance = words
        utterance.voice = voice
        self.speak(words)
    }
}


// let b = Karen2()
// b.say(words: AVSpeechUtterance(string: "Hello"), voice: AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.samantha.premium")!)



let a = SpeechSynth()
let utterance = AVSpeechUtterance(string: "Have nice day")
utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.yuri.premium")

a.speak(utterance)
let utterance2 = AVSpeechUtterance(string: "it is a great day.")
utterance2.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.yuri.premium")

a.speak(utterance2)















class Speech: AVSpeechSynthesizer {
    // var voice: NSSpeechSynthesizer.VoiceName
    
    let a = self
    let synth = NSSpeechSynthesizer()
    let speechDelegate = self
    
    var speakStarted: (() -> ()) = {}
    var speakComplete: (() -> ()) = {}
    
    override init() {
    }
}

extension Speech: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speakComplete()
    }
}


class SpeechDelegate: NSObject, NSSpeechSynthesizerDelegate {
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, willSpeakWord characterRange: NSRange, of string: String) {
        print("will speak")
        speakStarted()
    }
    
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        print("did speak")
        speakComplete()
    }
}





class Karen: Speech {
    
    let voiceKaren = NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.samantha")
    
    
    init() {
        
        synth.setVoice(voiceKaren)
        
        
        voice =
        blab = NSSpeechSynthesizer()
        blabDelegate = KarenDelegate()
        blab.setVoice(voice)
        blab.delegate = blabDelegate
        queue = DispatchQueue(label: "Queue")
        
    }
    
    
    func checkTrigger(inputPhrase: String) {
        queue.async {
            if self.blab.isSpeaking {
                return
            }
            
            for i in self.triggerAndBlab {
                if i[0].contains(inputPhrase) {
                    self.blab.startSpeaking(i[1])
                }
            }
        } // queue
    } // Karen.checkTrigger()
}

