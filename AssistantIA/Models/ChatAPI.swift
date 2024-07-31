//
//  ChatAPI.swift
//  AssistantIA
//
//  Created by Victor Brigido on 22/02/24.
//

import Foundation


func fetchChatCompletion(userMessage: String, completion: @escaping (Result<String, Error>) -> Void) {
  
    let apiUrl = URL(string: "https://api.openai.com/v1/chat/completions")!
    
 
    let requestData: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            [
                "role": "user",
                "content": userMessage
            ]
        ],
        "temperature": 1,
        "max_tokens": 256,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0
    ]
    
    // Converte o modelo JSON em dados
    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON data"])))
            return
        }
    
    // Crie a solicitação HTTP POST
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer sua_chave_aqui", forHTTPHeaderField: "Authorization") // Substitua Sua_chave_aqui pelo seu token de API
    
    // Configure os dados da solicitação
    request.httpBody = jsonData
    
    // Envie a solicitação
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Parse a resposta JSON
            do {
//                print("Resposta JSON recebida:", String(data: data, encoding: .utf8) ?? "")
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let choices = json["choices"] as? [[String: Any]], let completionMessage = choices.first?["message"] as? [String: Any], let content = completionMessage["content"] as? String {
                    completion(.success(content))
                } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let error = json["error"] as? [String: Any], let errorMessage = error["message"] as? String {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
}

