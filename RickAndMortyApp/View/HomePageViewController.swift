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
    var hasMoreContent = true
    var page = 1
    var characterList = [Results]()
    var characterCount = 0
    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        searchBar.delegate = self
        
        collectionViewConfigure()
        fetchCharacterCount()
        getData(page: page)
        
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
    func getData(page : Int){
        WebService.shared.getAllCharacterData(page: page) { result in
            switch result {
            case .success(let characters):
                if self.characterCount - self.characterList.count < 20 { self.hasMoreContent = false }
                self.characterList += characters
                self.characterListViewModel = CharacterListViewModel(resultList: self.characterList)
                DispatchQueue.main.async {
                    self.characterCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchCharacterCount(){
        WebService.shared.getCharacterCount { result in
            switch result{
            case .success(let response):
                self.characterCount = response?.info?.count ?? 0
            case .failure(let error):
                print(error)
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard hasMoreContent else { return }
            page += 1
            getData(page : page)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
}

extension HomePageViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchCharacter(searchText)
    }
    func searchCharacter(_ searchtext : String){
        WebService.shared.searchCharacterByName(searchText: searchtext) { result in
            switch result{
            case .success(let character):
                if character.count > 0 {
                    self.characterListViewModel = CharacterListViewModel(resultList: character)
                    DispatchQueue.main.async {
                        self.characterCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                self.characterListViewModel.searchNotFound()
                DispatchQueue.main.async {
                    self.characterCollectionView.reloadData()
                }
            }
        }
    }
}

