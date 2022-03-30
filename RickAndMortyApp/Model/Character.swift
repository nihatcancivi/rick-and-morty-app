//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Nihat on 25.03.2022.
//

import Foundation


struct Character: Decodable {
    let info: Info?
    let results: [Results]?
}

struct Info: Decodable {
    let count, pages: Int?
    let next, prev: String?
}


struct Results  : Decodable {
    let id : Int?
    let name : String?
    let status : String?
    let species : String?
    let type : String?
    let gender : String?
    let image : String?
    let location : Location
    let episode : [String]
}

struct Location : Decodable {
    let name : String?
    let url : String?
}
