//
//  HomePageViewModel.swift
//  RickAndMortyApp
//
//  Created by Nihat on 25.03.2022.
//

import Foundation

struct CharacterViewModel{
    
    let result : Results
    
    init(_ result : Results){
        self.result = result
    }
    
    var id : Int {
        return self.result.id ?? 0
    }
    var name : String {
        return self.result.name ?? ""
    }
    var status : String{
        return self.result.status ?? ""
    }
    var species : String {
        return self.result.species ?? ""
    }
    var type : String {
        return self.result.type ?? ""
    }
    var gender : String {
        return self.result.type ?? ""
    }
    var image : String {
        return self.result.image ?? ""
    }
    var location : Location {
        return self.result.location
    }
    var episode : [String] {
        return self.result.episode
    }
    
}
struct CharacterListViewModel {
    let resultList : [Results]
    
    func numberOfRowAt ()-> Int {
        return resultList.count
    }
    func cellForRowAt(_ index : Int) -> CharacterViewModel{
        let character = resultList[index]
        return CharacterViewModel(character)
    }
}
