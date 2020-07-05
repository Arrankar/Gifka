//
//  DataManager.swift
//  Gifka
//
//  Created by Александр on 04.07.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import UIKit

class DataManager {
   
    private let baseURL = "https://api.giphy.com/v1/gifs/search"
    private let apiKey = "iwsS9yvl4LDfr60t5I0yU4s6L1zBzuHp"
    
     func fetchGif(searchedGif: String, completion: @escaping ([Gifs]) -> Void) {

     
        let urlString = "\(baseURL)?api_key=\(apiKey)&q=\(searchedGif)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if let safeData = data {
                    guard let gifs = try? JSONDecoder().decode(GifResponse.self, from: safeData).data else { return }
                    DispatchQueue.main.async {
                        completion(gifs)
                    }
                }
            }
            task.resume()
        }
    }
}
