//
//  karen.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Cocoa



class Karen {
    
    let triggerAndBlab: [[String]] = [["manager", "The manager?  I want to see the manager!"], ["children", "My children?  Well I have 3 lovely children.  My eldest son is the captain of the soccer team, my youngest son is taking piano lessons and just got a college scholarship, he's also 8 by the way, and my daughter is taking jazz dance lessons but her teacher says perhaps she would be better suited to something with class like ballet.  She's also top of her class in every subject but that's normal these days.  I don't know how the school district is able to support her because how is she supposed to grow when there's no room left in the education system?"]]
    let voice: NSSpeechSynthesizer.VoiceName
    let blab: NSSpeechSynthesizer
    let queue: DispatchQueue
    
    init() {
        voice = NSSpeechSynthesizer.VoiceName(rawValue: "com.apple.speech.synthesis.voice.samantha")
        blab = NSSpeechSynthesizer()
        blab.setVoice(voice)
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
