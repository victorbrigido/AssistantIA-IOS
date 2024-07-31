//
//  TextInputView.swift
//  AssistantIA
//
//  Created by Victor Brigido on 23/02/24.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    var action: (String) -> Void
    @State private var internalText: String
    @Binding var recognizedText: String
    
    init(text: Binding<String>, action: @escaping (String) -> Void, recognizedText: Binding<String>) {
        self._text = text
        self.action = action
        self._internalText = State(initialValue: "")
        self._recognizedText = recognizedText
    }
    
    var body: some View {
        HStack {
            TextField("Digite aqui", text: $recognizedText)
                .frame(height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Button(action: {
                action(internalText.isEmpty ? recognizedText : internalText)
                recognizedText = ""
            }) {
                Image(systemName: "paperplane")
                    .font(.system(size: 25))
                    .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct TextInputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputView(text: .constant(""), action: { _ in }, recognizedText: .constant(""))
    }
}


