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
    let karen: Karen
    
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
        audioEngine.prepare()
        inputNode = audioEngine.inputNode
        bus = 0
        bufferSize = 1024
        recordingFormat = inputNode.outputFormat(forBus: bus)
        karen = Karen()
        
    } // Interrupter.init()
    
    
    func micToRequest() throws {
        try audioEngine.start()
        inputNode.installTap(onBus: bus, bufferSize: bufferSize, format: recordingFormat) {
            (buffer: AVAudioPCMBuffer, _) in
            self.bufferRecogRequest.append(buffer)
        }
    } // Interrupter.micToRequest()
    
    
    func recognize() {
        let recognitionTask = speechRecognizer.recognitionTask(with: bufferRecogRequest) {
            (result, error) in
            
            if let error = error {
                print(error)
            }
            
            if let result = result {
                self.karen.checkTrigger(inputPhrase: result.bestTranscription.formattedString)
            }
        }
    } // Interrupter.recognize()
    
}
