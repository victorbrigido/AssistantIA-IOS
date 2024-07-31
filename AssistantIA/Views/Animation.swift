//
//  Animation.swift
//  AssistantIA
//
//  Created by Victor Brigido on 22/02/24.
//

import SwiftUI

struct Animation: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            // Colored square
            Rectangle()
                .fill(isAnimating ? Color.red : Color.blue)
                .frame(width: 50, height: 50)
                .animation(.easeInOut(duration: 1.0)) // Adiciona animação
            
            // Animate button
            Button(action: {
                self.isAnimating.toggle()
            }) {
                Text("Animate")
                    .frame(width: 100, height: 50)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}

struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        Animation()
    }
}

