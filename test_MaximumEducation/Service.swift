//
//  Service.swift
//  test_MaximumEducation
//
//  Created by Andrey on 16.11.2021.
//

import Foundation

struct Service {
    
    let API_KEY = "ec694b4bb50b4ff48809bc9c0a00a999"
    let baseURL = "https://newsapi.org/v2/everything?q=Apple&sortBy=popularity&apiKey="
    
    func fetchData(completionHandler: @escaping ([Article])->()) {
        
        guard let url = URL(string: baseURL + API_KEY) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("API ERROR: \(error?.localizedDescription ?? "UNKNOWN ERROR TYPE")")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
                    do {
                        let result = try JSONDecoder().decode(News.self, from: data!)
                        completionHandler(result.articles)
                    } catch {
                        print("DECODE ERROR MESSAGE: \(error.localizedDescription)")
                    }
                } else if 400..<500 ~= response.statusCode {
                    print("Client error, status code: \(response.statusCode)")
                } else if 500..<600 ~= response.statusCode {
                    print("Server error, status code: \(response.statusCode)")
                }
            }
            
        }.resume()
    }
    
}
