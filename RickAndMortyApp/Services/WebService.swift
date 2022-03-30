//
//  WebService.swift
//  RickAndMortyApp
//
//  Created by Nihat on 26.03.2022.
//

import Foundation

class WebService {
    static let shared = WebService()
    private let baseURL = "https://rickandmortyapi.com/api/character/"
    //private init() {}
    
    func getAllCharacterData(page : Int,completed : @escaping(Result<[Results],ErrorMessage>) ->()){
        let endpoint = baseURL + "?page=\(page)"
        guard let url = URL(string: endpoint) else{
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
    func getCharacterCount(completed : @escaping(Result<Character?,ErrorMessage>)->()){
        let endpoint = baseURL
        guard let url = URL(string: endpoint)else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let characterCount = try decoder.decode(Character.self, from: data)
                completed(.success(characterCount))
                ///print(characterCount.info?.count)
            }catch{
                completed(.failure(.invalidData))
            }

        }
        task.resume()
    }
    func searchCharacterByName(searchText : String, completed : @escaping (Result<[Results] , ErrorMessage>)->()){
        let endpoint = baseURL + "?name=\(searchText.replacingOccurrences(of: " ", with: "+"))"
        guard let url = URL(string: endpoint)else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
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
