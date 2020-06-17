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


/*
 TO DO:
 Upon init:
  - installTap
  - SFSpeechAudioBuffer
  - Start speech recognition
 
  - once started:
  - removeTap
  - SFSpeechRecognition finish
  - SFSpeechAudioBuffer end, make nil? - Check to see if this dealloc memory
 
 */



// MARK: class Interrupter
class Interrupter {
    
    let speechRecognizer: SFSpeechRecognizer
    var bufferRecogRequest: SFSpeechAudioBufferRecognitionRequest?
    let audioEngine: AVAudioEngine
    let inputNode: AVAudioInputNode
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
    
    
    // MARK: init
    init() throws {
        
        if let sR = SFSpeechRecognizer(locale: Locale(identifier: "en-US")) {
            speechRecognizer = sR
        } else {
            throw Errors.speechRecognizerNotAvailable
        }
        
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        bus = 0
        bufferSize = 1024
        recordingFormat = inputNode.outputFormat(forBus: bus)
        karen = SpeechSynth()
        queue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        audioEngine.prepare()
        try audioEngine.start()
        
    } // Interrupter.init()
    
    
    // MARK: func micToRequest
    func micToRequest() throws {
        
        
    } // Interrupter.micToRequest()
    
    
    // MARK: func startRecognition
    func startRecognition() {
        print("starting recognition")
        
        bufferRecogRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let _ = bufferRecogRequest else {
            bufferRecogRequest = nil
            return
        }
        
        bufferRecogRequest!.shouldReportPartialResults = true
        bufferRecogRequest!.requiresOnDeviceRecognition = true
        
        self.inputNode.installTap(onBus: self.bus, bufferSize: self.bufferSize, format: self.recordingFormat) {
            (buffer: AVAudioPCMBuffer, _) in
            self.bufferRecogRequest!.append(buffer)
        }
        
        
        self.recognitionTask = self.speechRecognizer.recognitionTask(with: self.bufferRecogRequest!) {
            (result, error) in
            self.queue.async {
                
                if let error = error {
                    print("recognitionTask error: \(error)")
                }
                
                if let result = result {
                    self.words = result.bestTranscription.formattedString
                    print(result.bestTranscription.formattedString)
                    self.karen.checkTrigger(sentence: result.bestTranscription.formattedString)
                }
            } // queue.async
        } // recognitionTask
    } // Interrupter.recognize()
    
    
    func stopRecognition() {
        print("stopping recognition")
        self.bufferRecogRequest?.endAudio()
        self.recognitionTask?.finish()
        self.inputNode.removeTap(onBus: self.bus)
    }
    
    
} // class Interrupter
