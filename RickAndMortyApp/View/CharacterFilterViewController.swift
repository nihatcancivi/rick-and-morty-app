//
//  CharacterFilterViewController.swift
//  RickAndMortyApp
//
//  Created by Nihat on 31.03.2022.
//

import UIKit

class CharacterFilterViewController: UIViewController{
    
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var menuView: UIView!
    var genderPickerView = UIPickerView()
    var statusPickerView = UIPickerView()
    var characterGenderList = ["male","female","genderless","unknown"]
    var characterStatusList = ["alive","dead","unknown"]
    private var characterFilterVM : CharacterFilterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.layer.cornerRadius = 20
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        statusPickerView.delegate = self
        genderPickerView.dataSource = self
    
        genderTextField.inputView = genderPickerView
        statusTextField.inputView = statusPickerView
        
        genderPickerView.tag = 1
        statusPickerView.tag = 2
        
        self.characterFilterVM = CharacterFilterViewModel(characterGenderList: characterGenderList , characterStatusList : characterStatusList)
        
    }
    @IBAction func applyButtonClicked(_ sender: Any) {
        let filterDict : [String : String] = ["gender": genderTextField.text ?? "" , "status": statusTextField.text ?? ""]
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil , userInfo: filterDict)
        self.dismiss(animated: true, completion: nil)
    }
}
extension CharacterFilterViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return characterFilterVM.numberOfRowsInComponent(tag: pickerView.tag)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return characterFilterVM?.titleForRow(tag: pickerView.tag, row: row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1 :
            genderTextField.text = characterFilterVM.characterGenderList[row]
            genderTextField.resignFirstResponder()
        case 2 :
            statusTextField.text = characterFilterVM.characterStatusList[row]
            statusTextField.resignFirstResponder()
        default:
            return
        }
    }
}

