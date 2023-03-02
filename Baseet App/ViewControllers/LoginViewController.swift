//
//  ViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 07/07/22.
//

import UIKit
var otpValue:String!

class LoginViewController: UIViewController {

    let loginVM = LoginViewControllerVm()
    @IBOutlet weak var LoginwithNL: UILabel!
    @IBOutlet weak var EnterUrMnL: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var loginScrollView: UIScrollView!
    var devicdeID:String!
    
    @IBOutlet weak var numberTF: UITextField!{
        didSet{
            numberTF.leftImage(UIImage(named: "rightMark"), imageWidth: 10, padding: 20)
        }
    }
    var navigationClosure:(()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        devicdeID =  UIDevice.current.identifierForVendor!.uuidString
        print(devicdeID!)
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"
        {
//            let ar = UIImage(named: "arabic")
//            langButton.setImage(ar, for: .normal)
           
//            let en = UIImage(named: "en")
//            langButton.setImage(en, for: .normal)
         }
        
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
            numberTF.textAlignment = .left
            
        }else{
            numberTF.textAlignment = .left
            
        }
        
       
        numberTF.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter Mobile Number", comment: "")
        LoginwithNL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Login with Mobile Number", comment: "")
        EnterUrMnL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Enter your mobile number we will send you OTP to verify", comment: "")
        continueBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Continue", comment: ""), for: .normal)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]
          let _ = numbers[1]
      }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loginVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.loginVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.loginVM.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
//                self.navigationClosure?()
//                self.dismiss(animated: true, completion: nil)
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "OtpViewController") as! OtpViewController
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.loginVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                loginScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 100, right: 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        loginScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func continueActn(_ sender: Any) {
        
        self.loginVM.makeLoginCall(phoneNumber: self.numberTF.text ?? "")
    }
}


extension UITextField {
    func leftImage(_ image: UIImage?, imageWidth: CGFloat, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: padding, y: 0, width: imageWidth, height: frame.height)
        imageView.contentMode = .center
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 2 * padding, height: frame.height))
        containerView.addSubview(imageView)
        rightView = containerView
        rightViewMode = .always
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


