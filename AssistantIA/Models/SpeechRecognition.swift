//
//  SpeechRecognition.swift
//  AssistantIA
//
//  Created by Victor Brigido on 22/02/24.
//

import Foundation
import Speech
import UIKit
import AVFoundation



class AppDelegate: UIResponder, UIApplicationDelegate {
    
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let audioEngine = AVAudioEngine()

    override init() {
           
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        }
    
    
    func requestMicrophonePermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Permissão para usar o microfone concedida")
                case .denied:
                    print("Permissão para usar o microfone negada")
                case .restricted:
                    print("Acesso ao microfone restrito")
                case .notDetermined:
                    print("Permissão para usar o microfone ainda não determinada")
                @unknown default:
                    fatalError("Um novo caso de autorização foi adicionado")
                }
            }
        }
    }
}

class SpeechRecognition: ObservableObject {
    @Published var recognizedText = ""
    var textInputView: TextInputView?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    init() {
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    }
    
    func startRecording() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                print("Texto reconhecido: \(transcription)")
                self.recognizedText = transcription
            } else if let error = error {
                print("Erro durante o reconhecimento de fala: \(error.localizedDescription)")
            }
        }

        let inputNode = self.audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()
        try self.audioEngine.start()
        print("Gravação de áudio iniciada...")
    }

    func stopRecording() {
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest?.endAudio()
        print("Gravação de áudio encerrada.")
    }
    
    func updateTextInputView() {
        self.textInputView?.text = self.recognizedText
    }
    
    func stopRecordingAndUpdateText() {
        stopRecording()
        updateTextInputView()
    }
}
