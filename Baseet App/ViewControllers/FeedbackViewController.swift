//
//  FeedbackViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!{
        didSet{
            submitBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Submit", comment: ""), for: .normal)
        }
    }
    
    @IBOutlet weak var feedbackWordsLbl: UILabel!{
        didSet{
            feedbackWordsLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Give Some Feedback In Words", comment: "")
        }
    }
    
    @IBOutlet weak var rateYourExpLbl: UILabel!{
        didSet{
            rateYourExpLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate Your Overall Experience", comment: "")
        }
    }
    
    @IBOutlet weak var feedbackImproveLbl: UILabel!{
        didSet{
            feedbackImproveLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Your Feedback Improves The Delivery Experience", comment: "")
        }
    }
    
    @IBOutlet weak var deliveryLbl: UILabel!{
        didSet{
            deliveryLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "How is the Delivery", comment: "")
        }
    }
    
    @IBOutlet weak var feedbackMealLbl: UILabel!{
        didSet{
            feedbackMealLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Leave Feedback About Your Meal And Delivery", comment: "")
        }
    }
    
    @IBOutlet weak var rateOrderLbl: UILabel!{
        didSet{
            rateOrderLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rate Your Order", comment: "")
        }
    }
    
    @IBOutlet weak var feedbackHeadingLbl: UILabel!{
        didSet{
            feedbackHeadingLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Feedback", comment: "")
        }
    }
    
    @IBOutlet weak var feedbackScrollView: UIScrollView!
    @IBOutlet weak var starThree: UIImageView!
    @IBOutlet weak var starFive: UIImageView!
    @IBOutlet weak var starFour: UIImageView!
    @IBOutlet weak var starTwo: UIImageView!
    @IBOutlet weak var startOne: UIImageView!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var feedbackViewModel: FeedbackViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupActions()
        
        let disMissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(disMissKeyboardTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        commentsTextView.delegate = self
        commentsTextView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Tell About Service", comment: "")
        commentsTextView.textColor = UIColor.lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.feedbackViewModel?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.feedbackViewModel?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.feedbackViewModel?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.feedbackViewModel?.navigationClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "tabVC")
                vc.modalPresentationStyle = .fullScreen
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "tabVC")
        vc.modalPresentationStyle = .fullScreen
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        self.feedbackViewModel?.giveFeedBack(comment: self.commentsTextView.text ?? "")
    }
    
    func setupActions() {
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.actionOne))
        startOne.isUserInteractionEnabled = true
        startOne.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.actionTwo))
        starTwo.isUserInteractionEnabled = true
        starTwo.addGestureRecognizer(tapTwo)
        
        let tapThree = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.actionThree))
        starThree.isUserInteractionEnabled = true
        starThree.addGestureRecognizer(tapThree)
        
        let tapFour = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.actionFour))
        starFour.isUserInteractionEnabled = true
        starFour.addGestureRecognizer(tapFour)
        
        let tapFive = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.actionFive))
        starFive.isUserInteractionEnabled = true
        starFive.addGestureRecognizer(tapFive)
        
        commentsTextView.layer.borderWidth = 2
        commentsTextView.layer.cornerRadius = 5
        commentsTextView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    @objc
        func actionOne(sender:UITapGestureRecognizer) {
            DispatchQueue.main.async {
            self.feedbackViewModel?.finalRating = 1
            self.startOne.image = UIImage(systemName: "star.fill")
            self.starTwo.image = UIImage(systemName: "star")
            self.starThree.image = UIImage(systemName: "star")
            self.starFour.image = UIImage(systemName: "star")
            self.starFive.image = UIImage(systemName: "star")
            }
        }
    
    @objc
        func actionTwo(sender:UITapGestureRecognizer) {
            DispatchQueue.main.async {
            self.feedbackViewModel?.finalRating = 2
            self.startOne.image = UIImage(systemName: "star.fill")
            self.starTwo.image = UIImage(systemName: "star.fill")
            self.starThree.image = UIImage(systemName: "star")
            self.starFour.image = UIImage(systemName: "star")
            self.starFive.image = UIImage(systemName: "star")
            }
        }
    
    @objc
        func actionThree(sender:UITapGestureRecognizer) {
            DispatchQueue.main.async {
            self.feedbackViewModel?.finalRating = 3
            self.startOne.image = UIImage(systemName: "star.fill")
            self.starTwo.image = UIImage(systemName: "star.fill")
            self.starThree.image = UIImage(systemName: "star.fill")
            self.starFour.image = UIImage(systemName: "star")
            self.starFive.image = UIImage(systemName: "star")
            }
        }
    
    @objc
        func actionFour(sender:UITapGestureRecognizer) {
            DispatchQueue.main.async {
            self.feedbackViewModel?.finalRating = 4
            self.startOne.image = UIImage(systemName: "star.fill")
            self.starTwo.image = UIImage(systemName: "star.fill")
            self.starThree.image = UIImage(systemName: "star.fill")
            self.starFour.image = UIImage(systemName: "star.fill")
            self.starFive.image = UIImage(systemName: "star")
            }
        }
    
    @objc
        func actionFive(sender:UITapGestureRecognizer) {
            DispatchQueue.main.async {
            self.feedbackViewModel?.finalRating = 5
            self.startOne.image = UIImage(systemName: "star.fill")
            self.starTwo.image = UIImage(systemName: "star.fill")
            self.starThree.image = UIImage(systemName: "star.fill")
            self.starFour.image = UIImage(systemName: "star.fill")
            self.starFive.image = UIImage(systemName: "star.fill")
            }
        }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y  = 0
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}



extension FeedbackViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {

        if commentsTextView.textColor == UIColor.lightGray {
            commentsTextView.text = ""
            commentsTextView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentsTextView.text == "" {

            commentsTextView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Tell About Service", comment: "")
            commentsTextView.textColor = UIColor.lightGray
        }
        
    }
}
