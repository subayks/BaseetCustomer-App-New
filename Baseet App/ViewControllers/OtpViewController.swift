//
//  OtpViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

class OtpViewController: UIViewController,UITextFieldDelegate

{
    @IBOutlet weak var ArabicOtpTF: UITextField!
    
    @IBOutlet weak var stackViewOTP: UIStackView!
    
    @IBOutlet weak var vefyMblNumber: UILabel!
    
    @IBOutlet weak var otpnumber: UILabel!
    
    @IBOutlet weak var submitLbtn: UIButton!
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    
    var myTimer = Timer()
    var textDataField:String!
    
    var timerCount:Timer!
    var secondsToCount = 30
    var PhoneNumber:String!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        stackViewOTP.isHidden = true
        TF2.isHidden = true
        TF1.isHidden = true
        TF3.isHidden = true
        TF4.isHidden = true
        self.ArabicOtpTF.isHidden = false
        self.ArabicOtpTF.textAlignment = .center
        self.ArabicOtpTF.delegate = self
        PhoneNumber = UserDefaults.standard.string(forKey: "PhoneNumber")
        self.ArabicOtpTF.layer.cornerRadius = 5
        self.ArabicOtpTF.layer.borderColor = UIColor.red.cgColor
        self.ArabicOtpTF.layer.borderWidth = 1
        vefyMblNumber.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Verify Mobile Number", comment: "")
        otpnumber.text =  LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter OTP number send to your number", comment: "")
        submitLbtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "submit", comment: ""), for: .normal)
        ArabicOtpTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter OTP", comment: "")
        
      /*  TF1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        TF2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        TF3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        TF4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)*/
        
        print(PhoneNumber!)
        TF1.addBottomBorder()
        TF2.addBottomBorder()
        TF3.addBottomBorder()
        TF4.addBottomBorder()
        TF1.delegate = self
        TF2.delegate = self
        TF3.delegate = self
        TF4.delegate = self
        TF1.tag = 1
        TF2.tag = 2
        TF3.tag = 1
        TF4.tag = 2
        TF1.tintColor = UIColor.clear
        TF2.tintColor = UIColor.clear
        TF3.tintColor = UIColor.clear
        TF4.tintColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TF1.textContentType = .oneTimeCode
        TF2.textContentType = .oneTimeCode
        TF3.textContentType = .oneTimeCode
        TF4.textContentType = .oneTimeCode
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
 
    
    
    
    func getOtp(){
        textDataField = "\(TF1.text!)\(TF2.text!)\(TF3.text!)\(TF4.text!)"
        if TF1.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please OTP", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if TF2.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please OTP", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if TF3.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please OTP", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if TF4.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please OTP", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            if Reachability.isConnectedToNetwork(){
                let parameters = [
                    "otp": "\(self.textDataField!)",
                    "phone": "\(PhoneNumber!)"
                    ]
                    let url = "\(Constants.Common.finalURL)/auth/verlogin"
                print(parameters)
                print(url)
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                            response in
                            switch (response.result) {
                            case .success(let JSON):
                                print(response)
                                let response = JSON as! NSDictionary
                                 let token = "Bearer " + ((response["token"] as? String) ?? "")
                                print(token)
                                UserDefaults.standard.setValue(token, forKey: "AuthToken")
                                print(token)
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(identifier: "tabVC")
                                    vc.modalTransitionStyle = .coverVertical
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: true, completion: nil)
                                }
                               
                                break
                            case .failure:
                              
                                print(Error.self)
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                }))
                                self.present(alert, animated: true, completion: nil)
                                break
                            }
                        }
            }else{
                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }

        }
       
    }
    
    func ArabicOtp(){
        textDataField = "\(TF1.text!)\(TF2.text!)\(TF3.text!)\(TF4.text!)"
         if ArabicOtpTF.text == ""{
            let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Please Enter OTP", comment: ""), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }else
        {
            if Reachability.isConnectedToNetwork(){
                showLoadingView()
                let parameters = [
                    "otp": "\(self.ArabicOtpTF.text!)",
                    "phone": "974\(PhoneNumber!)"
                    ]
                    let url = "\(Constants.Common.finalURL)/auth/verlogin"
                print(parameters)
                print(url)
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                            response in
                            switch (response.result) {
                            case .success(let JSON):
                                print(response)
                                let response = JSON as! NSDictionary
                                 let token = "Bearer " + ((response["token"] as? String) ?? "")
                                print(token)
                                UserDefaults.standard.setValue(token, forKey: "AuthToken")
                                print(token)
                                let message = response["message"] as? String ?? ""
                                DispatchQueue.main.async {
                                    self.hideLoadingView()
                                    if message == "messages.phone_number_varified_successfully"{
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        loginBool = true
                                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                                        let vc = storyboard.instantiateViewController(identifier: "tabVC")
                                        vc.modalTransitionStyle = .coverVertical
                                        vc.modalPresentationStyle = .fullScreen
                                        self.present(vc, animated: true, completion: nil)
                                    }else{
                                        self.hideLoadingView()
                                        let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Phone number and otp not matched!", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    
                                }
                                break
                            case .failure:
                              
                                print(Error.self)
                                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                                }))
                                self.present(alert, animated: true, completion: nil)
                                break
                            }
                        }
            }else{
                let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: "Please Check Internet Connection"), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            }

        }
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString = (ArabicOtpTF.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        return newString.count <= maxLength
    }
    
    
  /*  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            if ((textField.text?.count)! < 1 ) && (string.count > 0) {
                if textField == TF1 {
                    TF2.becomeFirstResponder()
                }
                
                if textField == TF2 {
                    TF3.becomeFirstResponder()
                }
                
                if textField == TF3 {
                    TF4.becomeFirstResponder()
                }
                
                if textField == TF4 {
                    TF4.resignFirstResponder()
                }
                
                textField.text = string
                return false
            } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
                if textField == TF2 {
                    TF1.becomeFirstResponder()
                }
                if textField == TF3 {
                    TF2.becomeFirstResponder()
                }
                if textField == TF4 {
                    TF3.becomeFirstResponder()
                }
                if textField == TF1 {
                    TF1.resignFirstResponder()
                }
                
                textField.text = ""
                return false
            } else if (textField.text?.count)! >= 1 {
                textField.text = string
                return false
            }
        }else{
            if ((textField.text?.count)! < 1 ) && (string.count > 0) {
                if textField == TF4 {
                    TF3.becomeFirstResponder()
                }
                
                if textField == TF3 {
                    TF2.becomeFirstResponder()
                }
                
                if textField == TF2 {
                    TF1.becomeFirstResponder()
                }
                
                if textField == TF1 {
                    TF1.resignFirstResponder()
                }
                
                textField.text = string
                return false
            } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
                if textField == TF3 {
                    TF4.becomeFirstResponder()
                }
                if textField == TF2 {
                    TF3.becomeFirstResponder()
                }
                if textField == TF1 {
                    TF2.becomeFirstResponder()
                }
                if textField == TF4 {
                    TF4.resignFirstResponder()
                }
                
                textField.text = ""
                return false
            } else if (textField.text?.count)! >= 1 {
                textField.text = string
                return false
            }
        }
            
            
            return true
        }*/
    
    
    @IBAction func continueOtpActn(_ sender: Any) {
        self.ArabicOtp()
    }
    
}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    

}
