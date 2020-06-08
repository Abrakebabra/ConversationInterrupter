//
//  main.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation

print("Hello, World!")

var interrupter: Interrupter?

do {
    try interrupter = Interrupter()
}
catch let error {
    print(error)
}


var run = true

while run {
    let input = readLine()
    
    switch input {
    case "go":
        do {
            try interrupter?.micToRequest()
        }
        catch let error {
            print(error)
        }
        
        interrupter?.recognize()
        
    case "exit":
        run = false
        
    default:
        continue
    } // switch
}


