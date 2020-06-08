//
//  interrupter.swift
//  ConversationInterrupter
//
//  Created by Keith Lee on 2020/06/08.
//  Copyright © 2020 Keith Lee. All rights reserved.
//

import Foundation
import Speech
import AVFoundation


class Interrupter {
    
    let speechRecognizer: SFSpeechRecognizer
    let bufferRecogRequest: SFSpeechAudioBufferRecognitionRequest
    let audioEngine: AVAudioEngine
    let inputNode: AVAudioInputNode
    let bus: Int
    let bufferSize: AVAudioFrameCount
    let recordingFormat: AVAudioFormat
    
    enum Errors: Error {
        case speechRecognizerNotAvailable
    }
    
    var notification: (() -> ()) = {
        
    }
    
    init() throws {
        
        if let sR = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) {
            self.speechRecognizer = sR
        } else {
            throw Errors.speechRecognizerNotAvailable
        }
        self.bufferRecogRequest = SFSpeechAudioBufferRecognitionRequest()
        self.audioEngine = AVAudioEngine()
        self.audioEngine.prepare()
        self.inputNode = self.audioEngine.inputNode
        self.bus = 0
        self.bufferSize = 1024
        
        self.recordingFormat = self.inputNode.outputFormat(forBus: self.bus)
    } // Interrupter.init()
    
    
    func micToRequest() throws {
        try self.audioEngine.start()
        notification()
        self.inputNode.installTap(onBus: self.bus, bufferSize: self.bufferSize, format: self.recordingFormat) {
            (buffer: AVAudioPCMBuffer, _) in
            self.bufferRecogRequest.append(buffer)
        }
        
        
    } // Interrupter.micToRequest()
    
    
    
    func recognize() {
        let recognitionTask = SFSpeechRecognitionTask()
        
    } // Interrupter.recognize()
    
}
