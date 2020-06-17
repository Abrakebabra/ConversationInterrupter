//
//  main.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation

let commandQueue = DispatchQueue(label: "commandQueue")

let a = SpeechSynth()

var interrupter: Interrupter?

do {
    interrupter = try Interrupter()
    try interrupter?.micToRequest()
}
catch let error {
    print(error)
    exit(EXIT_SUCCESS)
}

var run = true

interrupter?.karen.speakStarted = {
    interrupter?.stopRecognition()
}

interrupter?.karen.speakComplete = {
    interrupter?.startRecognition()
}


let group2 = DispatchGroup()

commandQueue.async {
    while run {
        let input = readLine()
        
        switch input {
        case "go":
            interrupter?.startRecognition()
             
        case "exit":
            run = false
            exit(EXIT_SUCCESS)
        
        default:
            continue
        } // switch
    }
}





RunLoop.main.run()


