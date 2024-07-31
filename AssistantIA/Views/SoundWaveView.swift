//
//  SoundWaveView.swift
//  AssistantIA
//
//  Created by Victor Brigido on 25/02/24.
//


import SwiftUI

struct SoundWaveView: View {
    @State private var animationPhase: CGFloat = 0
    @State private var isAnimating = false
    @State private var timer: Timer? 

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0..<6) { index in
                        WaveLine(phase: animationPhase + CGFloat(index) * 0.2)
                            .stroke(Color.blue, lineWidth: 3)
                            .opacity(1 - Double(index) * 0.2)
                    }
                }
                .padding(.leading, -100)
                .frame(width: 400, height: 150)
                .onAppear {
                    startAnimation()
                }
            
            }
        }
    }
    
    func startAnimation() {
        // Inicia um Timer que atualiza a animationPhase continuamente
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            animationPhase -= 0.15 // Ajuste o incremento para a velocidade desejada
        }
    }
    
   func stopAnimation() {
        // Para o Timer quando a animação é interrompida
        timer?.invalidate()
        timer = nil
    }
}

struct WaveLine: Shape {
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()

        let wavelength = rect.width / 2
        let amplitude = rect.height / 4

        path.move(to: CGPoint(x: rect.minX, y: center.y))

        for x in stride(from: rect.minX, through: rect.maxX, by: 1) {
            let relativeX = x - rect.minX
            let sine = sin((CGFloat(x) / wavelength) * 2 * .pi + phase)
            let y = center.y + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}

struct SoundWaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundWaveView()
            .frame(width: 300, height: 250)
    }
}
