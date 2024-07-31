//
//  VoiceRecognition.swift
//  AssistantIA
//
//  Created by Victor Brigido on 23/02/24.
//

import Foundation
import AVFoundation
import UIKit

class ViewController: UIViewController {

    let synthesizer = AVSpeechSynthesizer()


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR") // Defina o idioma conforme necessário
        utterance.rate = 0.5 // Ajuste a velocidade conforme necessário (valor padrão é 0.5)
        synthesizer.speak(utterance)
    }

    @IBAction func speakButtonTapped(_ sender: UIButton) {
        speak(text: "Olá, mundo! Esta é uma mensagem de exemplo.")
        print("Teste de voz iniciado")
    }
}


