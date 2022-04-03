//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Nihat on 30.03.2022.
//

import UIKit
import Kingfisher

class CharacterDetailsViewController: UIViewController {
    
    var chosenCharacter : Results!

    @IBOutlet weak var characterSpeciesLabel: UILabel!
    @IBOutlet weak var characterGenderLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDetailsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chosenCharacter.name ?? "Character Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.characterDetailsImageView.layer.cornerRadius = 25
        
        if let url = URL(string: chosenCharacter.image!){
            characterDetailsImageView.kf.setImage(with: url)
        }
        characterNameLabel.text = chosenCharacter.name
        characterGenderLabel.text = chosenCharacter.gender
        characterSpeciesLabel.text = chosenCharacter.species
    }
}
