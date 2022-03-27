//
//  WebService.swift
//  RickAndMortyApp
//
//  Created by Nihat on 26.03.2022.
//

import Foundation

class WebService {
    static let shared = WebService()
    
    func getAllCharacterData(completed : @escaping(Result<[Results],ErrorMessage>) ->()){
        let urlString = "https://rickandmortyapi.com/api/character"
        guard let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let characters = try decoder.decode(Character.self, from: data)
                if let characters = characters.results {
                    completed(.success(characters))
                }else{
                    print("sıkıntı var")
                }
            }catch{
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
}
