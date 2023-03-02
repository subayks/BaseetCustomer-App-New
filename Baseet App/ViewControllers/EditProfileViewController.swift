//
//  EditProfileViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var titleUploadPhoto: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var editProfileViewModel: EditProfileViewModel?
    
    @IBOutlet weak var esitPrfilrL: UILabel!
    @IBOutlet weak var uploadL: UILabel!
    
    let fieldTitle = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "Name", comment: ""),
                      LocalizationSystem.sharedInstance.localizedStringForKey(key: "Email", comment: ""),
                      LocalizationSystem.sharedInstance.localizedStringForKey(key: "Location", comment: ""),
                      LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone Number", comment: "")]
    
    
   
    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Save", comment: ""), for: .normal)
        esitPrfilrL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "esitPrfilrL", comment: "")
        uploadL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "uploadL", comment: "")
        
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.profilePhoto.isUserInteractionEnabled = true
        self.profilePhoto.addGestureRecognizer(tapGestureRecognizer)
        self.userName.text = self.editProfileViewModel?.customerInfoModel?.fName
        profilePhoto.layer.borderWidth = 2
        profilePhoto.layer.borderColor = UIColor.red.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
        self.profilePhoto.loadImageUsingURL(self.editProfileViewModel?.customerInfoModel?.appImage)
        values = [self.editProfileViewModel?.customerInfoModel?.fName ?? "", self.editProfileViewModel?.customerInfoModel?.email ?? "", UserDefaults.standard.string(forKey: "Location_Info") ?? "", self.editProfileViewModel?.customerInfoModel?.phone ?? "", ""]
        self.editProfileViewModel?.firstName = self.editProfileViewModel?.customerInfoModel?.fName ?? ""
        self.editProfileViewModel?.emailID = self.editProfileViewModel?.customerInfoModel?.email ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
       view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.editProfileViewModel?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.editProfileViewModel?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.editProfileViewModel?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
               /* let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Successfully updated!", comment: ""), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)*/
            }
        }
        
        self.editProfileViewModel?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.dismiss(animated: true)
            }
        }
        
        self.editProfileViewModel?.allowToPhotos = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
                self.present(pickerController, animated: true)
            }
        }
        
        self.editProfileViewModel?.setProfileImageClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.profilePhoto.image = self.editProfileViewModel?.selectedImage
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                profileTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        profileTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
        
    @IBAction func editPback(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        view.endEditing(true)
        self.editProfileViewModel?.validateFields()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.editProfileViewModel?.requestPhotoAccess()
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.editProfileViewModel?.firstName = textField.text ?? ""
        } else if  textField.tag == 1 {
            self.editProfileViewModel?.emailID = textField.text ?? ""
        } else if textField.tag ==  4 {
            self.editProfileViewModel?.password = textField.text ?? ""
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else {
            selectedImageFromPicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        self.editProfileViewModel?.selectedImage = selectedImageFromPicker
        dismiss(animated: true)
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNameCell", for: indexPath) as! ProfileNameCell
        cell.overView.layer.cornerRadius = 10
        cell.nameTextfield.layer.borderColor = UIColor.clear.cgColor
        cell.labelTitle.text = fieldTitle[indexPath.row]
        cell.nameTextfield.text = values[indexPath.row]
        cell.nameTextfield.tag = indexPath.row
        if indexPath.row == 3 || indexPath.row == 2 {
            cell.nameTextfield.isUserInteractionEnabled = false
            cell.overView.alpha = 0.7
        } else {
            cell.nameTextfield.isUserInteractionEnabled = true
            cell.overView.alpha = 1
        }
        return cell
    }    
}
