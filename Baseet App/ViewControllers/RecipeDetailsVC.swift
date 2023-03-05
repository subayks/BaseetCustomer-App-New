//
//  RecipeDetailsVC.swift
//  Baseet App
//
//  Created by VinodKatta on 23/07/22.
//

import UIKit

class RecipeDetailsVC: UIViewController {
    
    @IBOutlet weak var quantityOverView: UIView!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var addOnLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var detailsScrollView: UIScrollView!
    @IBOutlet weak var addCommentsL: UILabel!
    @IBOutlet weak var AddonL: UILabel!
    @IBOutlet weak var RecipeDetails: UILabel!
    @IBOutlet weak var addtheBasketL: UIButton!
    @IBOutlet weak var textViewL: UITextView!
    @IBOutlet weak var buttonGoToCart: UIButton!
    @IBOutlet weak var cartCountBadge: UIButton!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    var priceItem:String!
    var ReceipImg:String!
    var itemDescription:String!
    var productNameItem:String!
    var recipeDetailsVCVM: RecipeDetailsVCVM?
    var itemCount = 1
    var itemAdded:((Int, Int, [AddOns])->())?
    var isFromHomeBanners:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if self.recipeDetailsVCVM?.proDuctDetailsModel?.addOns == nil || self.recipeDetailsVCVM?.proDuctDetailsModel?.addOns?.count == 0 {
        //            self.addOnLbl.isHidden = true
        //        } else {
        //            self.addOnLbl.isHidden = false
        //        }
        if isFromHomeBanners == "ReceipeBanners"{
            self.pricingLabel.text = priceItem ?? ""
            self.productName.text = productNameItem!
            self.discriptionLabel.text = itemDescription
            self.productImage.downloaded(from: ReceipImg)
        }else{
            let tap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsVC.tapFunction))
            addOnLbl.isUserInteractionEnabled = true
            addOnLbl.addGestureRecognizer(tap)
            self.setupValues()
            let disMissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(disMissKeyboardTap)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            self.addOnLbl.isHidden = true
            
            self.RecipeDetails.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "RecipeDetails", comment: "")
            self.AddonL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "AddonL", comment: "")
            //  self.addtheBasketL.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "addtheBasketL", comment: ""), for: .normal)
            self.addCommentsL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add Comments", comment: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recipeDetailsVCVM?.setUpItemsList()
        self.buttonGoToCart.layer.cornerRadius = buttonGoToCart.frame.height/2
        self.buttonGoToCart.clipsToBounds = true
        buttonGoToCart.layer.borderWidth = 2
        buttonGoToCart.layer.borderColor = UIColor.gray.cgColor
        
        self.cartCountBadge.layer.cornerRadius = cartCountBadge.frame.height/2
        self.cartCountBadge.clipsToBounds = true
        
        self.recipeDetailsVCVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.recipeDetailsVCVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.recipeDetailsVCVM?.reloadRecipieCollectionView = { [weak self] (itemCountValue) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                //                self.resDishTB.reloadData()
                //                self.resDishCV.reloadData()
                self.itemCount = itemCountValue
                self.labelCount.text = "\(itemCountValue)"
                self.checkForCartButton()
                
            }
        }
        
        self.recipeDetailsVCVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.recipeDetailsVCVM?.navigateToCartViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
                vc.restaurentFoodPicksVCVM = self.recipeDetailsVCVM?.getRestaurentFoodPicksVCVM()
                vc.changedValues  = { (itemCount, index) in
                    DispatchQueue.main.async {
                        self.recipeDetailsVCVM?.getCartCall()
                        //   self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
        self.recipeDetailsVCVM?.deleteClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                    do {
                        self.recipeDetailsVCVM?.deleteCart()
                    } catch {
                        print("Error")
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
        vc.addOnViewControllerVM = self.recipeDetailsVCVM?.getAddOnViewControllerVM()
        vc.addOns  = { (addOns) in
            DispatchQueue.main.async {
                self.recipeDetailsVCVM?.updateAdons(addOns: addOns)
            }
        }
        vc.modalTransitionStyle  = .crossDissolve
        // vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonAddItem(_ sender: Any) {
        itemCount = itemCount + 1
        self.navigateToAdOnView(itemCount: itemCount, index: 0, isIncrementFlow: true)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionReduceItem(_ sender: Any) {
        if itemCount > 1 || itemCount == 1 {
            itemCount = itemCount - 1
            self.labelCount.text = "\(itemCount)"
            self.recipeDetailsVCVM?.decideFlow(itemCount: itemCount, index: 0, isIncrementFlow: false)
        }
    }
    
    @IBAction func addToBasketBtn(_ sender: Any) {
        if isFromHomeBanners == "ReceipeBanners"{
            
        }else{
            self.itemAdded?(itemCount, self.recipeDetailsVCVM?.index ?? 0, self.recipeDetailsVCVM?.setupAdons() ?? [AddOns()])
            self.dismiss(animated: true,completion: nil)
        }
        
    }
    
    func checkForCartButton() {
        let showButton = self.recipeDetailsVCVM?.isItemAvailable()
        self.buttonGoToCart.isHidden = !showButton!
        self.cartCountBadge.isHidden = !showButton!
        if showButton == false {
            self.buttonTopConstraint.constant = 15
            self.labelCount.text = "0"
        } else {
            let cartCount = "\(self.recipeDetailsVCVM?.getCartModel?.data?.count ?? 0)"
            self.cartCountBadge.setTitle(cartCount, for: .normal)
            self.buttonTopConstraint.constant = 0
        }
    }
    
    func setupValues() {
        self.quantityOverView.layer.borderWidth = 1
        self.commentsTextView.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add your Comment Here", comment: "")
        
        self.quantityOverView.layer.borderColor = UIColor(red: 172/255, green: 37/255, blue: 23/255, alpha: 1).cgColor
        
        self.productImage.loadImageUsingURL(self.recipeDetailsVCVM?.proDuctDetailsModel?.appimage ?? "")
        self.productName.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.name ?? ""
        self.discriptionLabel.text = self.recipeDetailsVCVM?.proDuctDetailsModel?.description ?? ""
        self.labelCount.text = "\(self.recipeDetailsVCVM?.proDuctDetailsModel?.itemQuantity ?? 0)"
        self.itemCount = self.recipeDetailsVCVM?.proDuctDetailsModel?.itemQuantity ?? 0
        self.pricingLabel.text = "QR \(self.recipeDetailsVCVM?.proDuctDetailsModel?.price ?? 0)"
    }
    
    @IBAction func actionGotoBasket(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.recipeDetailsVCVM?.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                self.recipeDetailsVCVM?.getCartCall(isFromCartScreen: true)
                //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    
    func navigateToAdOnView(itemCount: Int, index: Int, addon: [AddOns]? = nil, isIncrementFlow: Bool) {
        let foodItem = self.recipeDetailsVCVM?.proDuctDetailsModel
        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 > 0 {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
            vc.addOnViewControllerVM = self.recipeDetailsVCVM?.getAddOnViewControllerVM(index: index)
            vc.addOns  = { (addOns) in
                DispatchQueue.main.async {
                    self.recipeDetailsVCVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
                }
            }
            vc.makeCartCall = {
                self.recipeDetailsVCVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isIncrementFlow)
            }
            vc.modalTransitionStyle  = .crossDissolve
            // vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            self.recipeDetailsVCVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isIncrementFlow)
        }
    }
}

extension RecipeDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
