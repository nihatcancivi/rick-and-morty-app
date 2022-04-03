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
    var selectedCharacter : Results!
    var filterList = [String]()
    var filtered = false
    var searchList = [Results]()
    var search = false
    var searchText = ""
    var pageCount = 1

    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        searchBar.delegate = self
        
        let filterIcon = UIImage(named: "filterIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image : filterIcon, style: UIBarButtonItem.Style.plain, target: self, action: #selector(showFilterMenu))
        
        collectionViewConfigure()
        fetchCharacterCount()
        getData(page: page)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getFilteredCharacters(_:)), name: NSNotification.Name("newData"), object: nil)
    }
    @objc func showFilterMenu(){
        performSegue(withIdentifier: "toFilterMenu", sender: nil)
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
        self.filtered = false
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
    
    func searchCharacterCount(searchText : String){
        WebService.shared.searchCharacterCount(searchText: searchText){ result in
            switch result{
            case .success(let response):
                self.pageCount = response?.info?.pages ?? 0
            case .failure(let error):
                print(error)
            }
        }
    }
    @objc func getFilteredCharacters(_ notification: NSNotification){
        self.filtered = true
        if let gender = notification.userInfo?["gender"] as? String{
            if let status = notification.userInfo?["status"] as? String {
                WebService.shared.getFilteredCharacters(gender: gender, status: status) { result in
                    switch result{
                    case .success(let character):
                        if character.count > 0 {
                            self.characterListViewModel = CharacterListViewModel(resultList: character)
                            DispatchQueue.main.async {
                                self.characterCollectionView.reloadData()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if filtered == false{
            let offsetY = scrollView.contentOffset.y
            let contentHeight = (scrollView.contentSize.height) - 250
            let height = scrollView.frame.size.height
            if offsetY > contentHeight - height {
                guard hasMoreContent else { return }
                page += 1
                if search == false {
                    getData(page : page)
                }
                else{
                    if page <= pageCount{
                        searchCharacter(page: page,self.searchText)
                    }
                }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCharacter = characterListViewModel.resultList[indexPath.row]
        performSegue(withIdentifier: "toCharacterDetailsVC", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCharacterDetailsVC"{
            let destinationVC = segue.destination as! CharacterDetailsViewController
            destinationVC.chosenCharacter = selectedCharacter
        }
    }
}

extension HomePageViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search = true
        searchCharacterCount(searchText: searchText)
        self.searchText = searchText
        self.searchList.removeAll(keepingCapacity: false)
        searchCharacter(page : 1 , self.searchText)
        if searchText == "" {
            search = false
            page = 1
            characterList.removeAll(keepingCapacity: false)
            getData(page: page)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchCharacter(page : Int , _ searchtext : String){
        print(self.characterListViewModel.numberOfRowAt())
        WebService.shared.searchCharacterByName(page : page ,searchText: searchtext) {  result in
            switch result{
            case .success(let characters):
                if characters.count > 0 {
                    self.searchList += characters
                    self.characterListViewModel = CharacterListViewModel(resultList: self.searchList)
                    DispatchQueue.main.async {
                        self.characterCollectionView.reloadData()
                    }
                }
            case .failure(_):
                self.characterListViewModel.searchNotFound()
                DispatchQueue.main.async {
                    self.characterCollectionView.reloadData()
                }
            }
        }
    }
}

