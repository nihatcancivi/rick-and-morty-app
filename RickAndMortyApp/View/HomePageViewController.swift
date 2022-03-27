//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Nihat on 25.03.2022.
//

import UIKit
import Kingfisher

class HomePageViewController: UIViewController {
    
    private var characterListViewModel : CharacterListViewModel!

    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        
        collectionViewConfigure()
        getData()
    }
    func collectionViewConfigure(){
        let design : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let witdh = self.characterCollectionView.frame.size.width
        let cellWidth = (witdh-30)/3
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.itemSize = CGSize(width: cellWidth , height: cellWidth * 1.4)
        design.minimumInteritemSpacing = 5
        design.minimumLineSpacing = 5
        characterCollectionView!.collectionViewLayout = design
    }
    func getData(){
        WebService.shared.getAllCharacterData { result in
            switch result {
            case .success(let characters):
                self.characterListViewModel = CharacterListViewModel(resultList: characters)
                DispatchQueue.main.async {
                    self.characterCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension HomePageViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterListViewModel == nil ? 0 : self.characterListViewModel.numberOfRowAt()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        let characterViewModel = characterListViewModel.cellForRowAt(indexPath.row)
        cell.characterNameLabel.text = characterViewModel.name
        cell.characterStatus.text = characterViewModel.status
        let url = URL(string: characterViewModel.image)
        cell.characterImage.kf.setImage(with: url)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

