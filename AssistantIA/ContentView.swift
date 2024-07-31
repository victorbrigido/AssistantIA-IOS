//
//  ContentView.swift
//  AssistantIA
//
//  Created by Victor Brigido on 22/02/24.
//

import SwiftUI
import Speech

struct ContentView: View {
    @StateObject private var speechRecognition = SpeechRecognition()
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var microphonePermissionStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var responseText = ""
    @State private var text = ""
    @State private var isAnimatingWave = false
    
    
    let synthesizer = AVSpeechSynthesizer()
    
    
    var body: some View {
        VStack {
            Text("Microphone Permission Status: \(permissionDescription(for: microphonePermissionStatus))")
                .padding()
            
            Button(action: {
                requestMicrophonePermission()
            }) {
                Text("Request Microphone Permission")
            }
            
            Button {
                speak(text: responseText)
            } label: {
                Image(systemName: "speaker.wave.2")
                    .font(.system(size: 40))
            }
            .padding(.top, 20)
            
            Spacer()
            
            VStack {
                ScrollView {
                    Text(responseText)
                        .padding()
                }
            }
            Spacer()
            
            if isRecording {
                if isAnimatingWave {
                    SoundWaveView()
                }
                    Text("Ouvindo: \(recognizedText)")
                }
            
            
            Button(action: {
                if isRecording {
                    speechRecognition.stopRecording()
                    isAnimatingWave = false
                } else {
                    do {
                        try speechRecognition.startRecording()
                        isAnimatingWave = true
                        SoundWaveView().startAnimation()
                    } catch {
                        recognizedText = "Erro ao iniciar o reconhecimento de fala"
                    }
                }
                isRecording.toggle()
            }) {
                Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                    .imageScale(.large)
                    .font(.system(size: 50))
            }
            
            TextInputView(text: $text, action: sendText, recognizedText: $recognizedText)
                            .environmentObject(speechRecognition)
            
        }
        .onAppear {
            // Solicitar permissão para usar o microfone quando a visualização aparecer
            requestMicrophonePermission()
        }
        .onReceive(speechRecognition.$recognizedText) { newText in
                    recognizedText = newText
        }
    }
    
    func permissionDescription(for status: SFSpeechRecognizerAuthorizationStatus) -> String {
        switch status {
        case .authorized:
            return "Authorized"
        case .denied:
            return "Denied"
        case .restricted:
            return "Restricted"
        case .notDetermined:
            return "Not Determined"
        @unknown default:
            return "Unknown"
        }
    }
    
    func requestMicrophonePermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                self.microphonePermissionStatus = authStatus
            }
        }
    }
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.rate = 0.5 // Ajuste a velocidade conforme necessário (valor padrão é 0.5)
        synthesizer.speak(utterance)
    }
    
    func sendText(_ text: String) {
        fetchChatCompletion(userMessage: text) { result in
            switch result {
            case .success(let response):
                self.responseText = response
                print("Resposta do assistente: \(response)")
            case .failure(let error):
                print("Erro ao obter resposta do assistente: \(error)")
            }
        }
    }
    
    func updateRecognizedText(_ text: String) {
            self.recognizedText = text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
