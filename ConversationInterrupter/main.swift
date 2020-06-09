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




while run {
    let input = readLine()
    
    switch input {
    case "manager":
        a.checkTrigger(sentence: "manager")
        
    case "children":
        a.checkTrigger(sentence: "children")
        
    case "exit":
        run = false
        testGroup.leave()
        
    default:
        continue
    } // switch
}




testGroup.wait()
