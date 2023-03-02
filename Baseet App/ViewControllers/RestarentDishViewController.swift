//
//  RestarentDishViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit
import CoreMedia

class RestarentDishViewController: UIViewController {
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var locationName: UIButton!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    @IBOutlet weak var cartCountBadge: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reatingStackView: UIStackView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var searchTFL: UITextField!
    @IBOutlet weak var buttonGoToCart: UIButton!
    @IBOutlet weak var restaurantAddress: UILabel!
    var menu_vc1: RecipeDetailsVC!
    
    @IBOutlet weak var resDishCV: UICollectionView!
    
    @IBOutlet weak var resDishTB: UICollectionView!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    
    var previousIndex: IndexPath?
    var isSelected = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchTFL.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search for Restaurants, Items & more", comment: "")
        
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//       view.addGestureRecognizer(tap)
        resDishTB.delegate = self
        resDishTB.dataSource = self
        menu_vc1 = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailsVC") as? RecipeDetailsVC
        setupValues()
        self.restarentDishViewControllerVM?.setUpItemsList()
        self.setupNavigationBar()
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        //        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        //        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGesture))
        //        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        //        self.view.addGestureRecognizer(swipeLeft)
        //        self.view.addGestureRecognizer(swipeRight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.buttonGoToCart.layer.cornerRadius = buttonGoToCart.frame.height/2
        self.buttonGoToCart.clipsToBounds = true
        buttonGoToCart.layer.borderWidth = 2
        buttonGoToCart.layer.borderColor = UIColor.gray.cgColor
        
        self.cartCountBadge.layer.cornerRadius = cartCountBadge.frame.height/2
        self.cartCountBadge.clipsToBounds = true
        
        self.restarentDishViewControllerVM?.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.restarentDishViewControllerVM?.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.restarentDishViewControllerVM?.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RecipeDetailsVC") as! RecipeDetailsVC
             //   vc.recipeDetailsVCVM = self.restarentDishViewControllerVM?.getRecipeDetailsVCVM(index: <#Int#>)
                vc.itemAdded  = { (itemCount, index, addOns) in
                    DispatchQueue.main.async {
                //        self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index, addOns: addOns)
              //      self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
                        self.navigateToAdOnView(itemCount: itemCount, index: index, addon: addOns, isIncrementFlow: false)
                    }
                }
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.reloadRecipieCollectionView = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.resDishTB.reloadData()
                self.resDishCV.reloadData()
                self.checkForCartButton()
            }
        }
        
        self.restarentDishViewControllerVM?.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.navigateToCartViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
                vc.restaurentFoodPicksVCVM = self.restarentDishViewControllerVM?.getRestaurentFoodPicksVCVM()
                vc.changedValues  = { (itemCount, index) in
                    DispatchQueue.main.async {
                        self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
                     //   self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
                    }
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.addFavouriteClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.buttonFavourite.setImage(UIImage(named: "Favourite"), for: .normal)
            }
        }
        
        self.restarentDishViewControllerVM?.removeFavClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.buttonFavourite.setImage(UIImage(named: "UnFavourite"), for: .normal)
            }
        }
        
        self.restarentDishViewControllerVM?.deleteClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                    do {
                        self.restarentDishViewControllerVM?.deleteCart()
                    } catch {
                        print("Error")
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.restarentDishViewControllerVM?.showAdOnClosure = { [weak self] (itemCount, index, addOn) in
            DispatchQueue.main.async {
                guard let self = self else {return}
            //    self.navigateToAdOnView(itemCount: itemCount, index: index, addon: addOn)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setupNavigationBar() {
        self.locationName.setTitle(UserDefaults.standard.string(forKey: "City_Name"), for: .normal)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
    
    func checkForCartButton() {
        let showButton = self.restarentDishViewControllerVM?.isItemAvailable()
        self.buttonGoToCart.isHidden = !showButton!
        self.cartCountBadge.isHidden = !showButton!
        if showButton == false {
           // self.collectionViewBottomConstraint.constant = 66
        } else {
            let cartCount = "\(self.restarentDishViewControllerVM?.getCartModel?.data?.count ?? 0)"
            self.cartCountBadge.setTitle(cartCount, for: .normal)
         //   self.collectionViewBottomConstraint.constant = 130
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionGoToBasket(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.restarentDishViewControllerVM?.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
              //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupValues() {
        let startTime = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.availableTimeStarts ?? ""
        let closingTime = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.availableTimeEnds ?? ""
        
        let dateAsString = closingTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let formattedClosingDate = dateFormatter.string(from: date ?? Date())
        
        self.timingLabel.text = "Timing \(startTime) AM to \(formattedClosingDate)"
        self.logoImage.layer.cornerRadius = 20
        self.logoImage.clipsToBounds = true
        self.logoImage.loadImageUsingURL(self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.applogo ?? "")
        self.restaurantName.text = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.name
        self.restaurantAddress.text = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.address
        self.buttonGoToCart.isHidden  = true
        self.cartCountBadge.isHidden = true
        let ratingCount = self.restarentDishViewControllerVM?.shopDetailsModel?.restaurant?.avgRating ?? 0
        if ratingCount > 0  {
            self.ratingLabel.text = "Rating"
            for i in 0..<ratingCount {
            let imageStar = UIImageView()
            imageStar.image = UIImage(systemName: "star.fill")
            imageStar.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
            self.reatingStackView.addArrangedSubview(imageStar)
        }
        } else {
            self.ratingLabel.text = ""
        }
    }
    
    @IBAction func actionFavourite(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
        if sender.currentImage == UIImage(named: "Favourite") {
            self.restarentDishViewControllerVM?.removeFavouriteCall()
        } else {
            self.restarentDishViewControllerVM?.addToFavouriteCall()
        }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please login for adding item to favourites", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionShare(_ sender: Any) {
        let textToShare = "Baseet"
        if let myWebsite = NSURL(string: "https://apps.apple.com/in/app/baseet-%D8%A8%D8%B3%D9%8A%D8%B7-food-shopping/id1661531953") {
            let objectsToShare: [Any] = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
}

extension RestarentDishViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.resDishCV {
            return self.restarentDishViewControllerVM?.foodItemList().count ?? 0
        }
        return self.restarentDishViewControllerVM?.foodItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.resDishCV {
            let cellA = resDishCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewSecCell
            cellA.lbl.text = self.restarentDishViewControllerVM?.foodItemList()[indexPath.row]
            cellA.lblview.layer.borderColor = UIColor.clear.cgColor
            return cellA
        } else {
            let cellC = resDishTB.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ResDishCollectionViewCellTwo
            cellC.buttonAdd.layer.cornerRadius = 10
            cellC.resDishCollectionViewCellTwoVM = self.restarentDishViewControllerVM?.getResDishCollectionViewCellTwoVM(index: indexPath.row)
            cellC.buttonAdd.tag = indexPath.row
            cellC.buttonAdd.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "addBtn", comment: ""), for: .normal)
            cellC.itemAdded  = { (itemCount, index, isAdded) in
                DispatchQueue.main.async {
                   // self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index)
              //    self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index)
                    if isAdded {
                        self.navigateToAdOnView(itemCount: itemCount, index: index, isIncrementFlow: isAdded)
                    } else {
                        self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isAdded)
                    }
                }
            }
            return cellC
        }
    }
    
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//               let padding: CGFloat =  50
//               let collectionViewSize = collectionView.frame.size.width - padding
//
//               return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//           }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/2.0

        return CGSize(width: yourWidth, height: 320)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // self.restarentDishViewControllerVM?.makeProductDetailsCall(item: indexPath.row)
        if collectionView == self.resDishCV {
            let cell: HomeCollectionViewSecCell = resDishCV.cellForItem(at: indexPath) as! HomeCollectionViewSecCell
            cell.lblview.backgroundColor = UIColor(red: 199/255, green: 48/255, blue: 41/255, alpha: 1)
            cell.lbl.textColor = .white
            if previousIndex !=  nil  {
                let previousCell: HomeCollectionViewSecCell = resDishCV.cellForItem(at: previousIndex ?? IndexPath()) as! HomeCollectionViewSecCell
                previousCell.lblview.backgroundColor = UIColor.systemGray6
                previousCell.lbl.textColor = .black
            }
            if previousIndex == indexPath {
                isSelected = false
                previousIndex = nil
            } else {
                isSelected = true
                self.previousIndex = indexPath
            }
            return
        }
        if self.restarentDishViewControllerVM?.foodItems?[indexPath.row].qty != nil &&
            ((self.restarentDishViewControllerVM?.foodItems?[indexPath.row].qty ?? "") as NSString).integerValue > 0 {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.recipeDetailsVCVM = self.restarentDishViewControllerVM?.getRecipeDetailsVCVM(index: indexPath.row)
        vc.itemAdded  = { (itemCount, index, addOns) in
            DispatchQueue.main.async {
            //    self.restarentDishViewControllerVM?.updateValues(itemCount: itemCount, index: index, addOns: addOns)
             //   self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
             //   self.navigateToAdOnView(itemCount: itemCount, index: index, addon: addOns)
            }
        }
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    func navigateToAdOnView(itemCount: Int, index: Int, addon: [AddOns]? = nil, isIncrementFlow: Bool) {
        let foodItem = self.restarentDishViewControllerVM?.foodItems?[index]
        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 > 0 {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
        vc.addOnViewControllerVM = self.restarentDishViewControllerVM?.getAddOnViewControllerVM(index: index)
        vc.addOns  = { (addOns) in
            DispatchQueue.main.async {
                self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns, isIncrementFlow: isIncrementFlow)
            }
        }
        vc.makeCartCall = {
            self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isIncrementFlow)
        }
        vc.modalTransitionStyle  = .crossDissolve
       // vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        } else {
            self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, isIncrementFlow: isIncrementFlow)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((resDishTB.contentOffset.y + resDishTB.frame.size.height) >= resDishTB.contentSize.height)
        {
            DispatchQueue.main.async {
                 self.restarentDishViewControllerVM?.makeLoadMore()
            }
        }
    }
}

extension RestarentDishViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

