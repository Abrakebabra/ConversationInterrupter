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
import Cocoa


class Interrupter {
    
    let speechRecognizer: SFSpeechRecognizer
    let bufferRecogRequest: SFSpeechAudioBufferRecognitionRequest
    let audioEngine: AVAudioEngine
    let inputNode: AVAudioInputNode
    let test = NSSpeechRecognizer()
    let bus: Int
    let bufferSize: AVAudioFrameCount
    let recordingFormat: AVAudioFormat
    var recognitionTask: SFSpeechRecognitionTask?
    let karen: SpeechSynth
    let queue: DispatchQueue
    var words: String = ""
    
    enum Errors: Error {
        case speechRecognizerNotAvailable
    }
    
    
    
    init() throws {
        
        if let sR = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) {
            speechRecognizer = sR
        } else {
            throw Errors.speechRecognizerNotAvailable
        }
        
        bufferRecogRequest = SFSpeechAudioBufferRecognitionRequest()
        bufferRecogRequest.shouldReportPartialResults = true
        bufferRecogRequest.requiresOnDeviceRecognition = true
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        bus = 0
        bufferSize = 1024
        recordingFormat = inputNode.outputFormat(forBus: bus)
        karen = SpeechSynth()
        queue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        
    } // Interrupter.init()
    
    
    func micToRequest() throws {
        self.inputNode.installTap(onBus: self.bus, bufferSize: self.bufferSize, format: self.recordingFormat) {
            (buffer: AVAudioPCMBuffer, _) in
            self.bufferRecogRequest.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
    } // Interrupter.micToRequest()
    
    
    func recognize() {
        print("recognize initialized")
        self.recognitionTask = self.speechRecognizer.recognitionTask(with: self.bufferRecogRequest) {
            (result, error) in
            self.queue.async {
                self.words = result?.bestTranscription.formattedString as! String
                print("recognitionTask closure called")
                if let error = error {
                    print(error)
                }
                
                if let result = result {
                    self.words = result.bestTranscription.formattedString
                    print(result.bestTranscription.formattedString)
                    //self.karen.checkTrigger(inputPhrase: result.bestTranscription.formattedString)
                }
            }
            
        }
        
        
    } // Interrupter.recognize()
    
}
