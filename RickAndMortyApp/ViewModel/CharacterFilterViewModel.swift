//
//  CharacterFilterViewModel.swift
//  RickAndMortyApp
//
//  Created by Nihat on 2.04.2022.
//

import Foundation
import SwiftUI

struct CharacterFilterViewModel {
    var characterGenderList : [String]
    var characterStatusList : [String]
    
    func numberOfRowsInComponent(tag : Int) ->Int{
        switch tag {
        case 1 :
            return characterGenderList.count
        case 2 :
            return characterStatusList.count
        default:
            return 1
        }
    }
    func titleForRow(tag : Int , row : Int)->String{
        switch tag {
        case 1 :
            return characterGenderList[row]
        case 2 :
            return characterStatusList[row]
        default:
            return "Data not Found"
        }
    }
    func didSelectRow(tag : Int , row : Int)->String{
        switch tag {
        case 1 :
            return characterGenderList[row]
        case 2 :
            return characterStatusList[row]
        default:
            return "Data not Found"
        }
        
    }
}
