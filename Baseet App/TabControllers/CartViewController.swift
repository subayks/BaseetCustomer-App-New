//
//  CartViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cartTB: UITableView!
    var cartViewControllerVM = CartViewControllerVM()
    var restarentDishViewControllerVM: RestarentDishViewControllerVM?
    
    @IBOutlet weak var noitemLblL: UILabel!
    @IBOutlet weak var cartLblL: UILabel!
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Cart", comment: "")
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        setupNavigationBar()
        cartTB.delegate = self
        cartTB.dataSource = self
        cartTB.allowsSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            cartTB.isHidden = true
            button.isHidden = true
            let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
            vc!.modalPresentationStyle = .fullScreen
            isfromcart = "isfromCartLogin"
            self.present(vc!, animated: true, completion: nil)
        }else{
            cartTB.isHidden = false
            button.isHidden = false
            self.cartViewControllerVM.getCartCall()
            
            self.cartViewControllerVM.showLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.showLoadingView()
                }
            }
            
            self.cartViewControllerVM.hideLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.hideLoadingView()
                }
            }
            
            self.cartViewControllerVM.reloadRecipieCollectionView = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.cartTB.reloadData()
                }
            }
            
            self.cartViewControllerVM.alertClosure = { [weak self] (error) in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    func setupNavigationBar() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false {
            self.profileIcon.isHidden = true
            self.userName.isHidden = true
        } else {
            self.profileIcon.isHidden = false
            self.userName.isHidden = false
            self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
        }
    }
}

extension CartViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewControllerVM.getCartModel?.data?.count == 0 ? 1:  (cartViewControllerVM.getCartModel?.data?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cartViewControllerVM.getCartModel?.data?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartCell", for: indexPath) as! EmptyCartCell
            cell.noItemavail.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "No item avaliable", comment: "")
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
            cell.CartTableViewCellVM = self.cartViewControllerVM.getCartTableViewCellVM(index: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       /* let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.cartViewControllerVM.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                //   self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
                //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)*/
    }
    
    
//    func navigateToAdOnView(itemCount: Int, index: Int, addon: [AddOns]? = nil) {
//        let foodItem = self.restarentDishViewControllerVM?.foodItems?[index]
//        if foodItem?.addOns != nil && foodItem?.addOns?.count ?? 0 > 0 {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "AddOnViewController") as! AddOnViewController
//        vc.addOnViewControllerVM = self.restarentDishViewControllerVM?.getAddOnViewControllerVM(index: index)
//        vc.addOns  = { (addOns) in
//            DispatchQueue.main.async {
//                self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: addOns)
//            }
//        }
//        vc.modalTransitionStyle  = .crossDissolve
//       // vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
//        } else {
//            self.restarentDishViewControllerVM?.decideFlow(itemCount: itemCount, index: index, addOns: <#[AddOns]#>)
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cartViewControllerVM.getCartModel?.data?.count == 0 {
          return 0
        }else{
            return 50
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
       footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:
       100)
        if LocalizationSystem.sharedInstance.getLanguage() == "en"{
             button.frame = CGRect(x: 20, y: 10, width: self.cartTB.frame.width-50, height: 50)
            button.setTitle("Check Out", for: .normal)
             button.layer.cornerRadius = 10.0
             button.layer.borderColor = UIColor.red.cgColor
             button.layer.borderWidth = 1.0
             button.setTitleColor(UIColor.white, for: .normal)
             button.backgroundColor = UIColor.red
             button.addTarget(self, action: #selector(checkOutBtn), for: .touchUpInside)
            footerView.addSubview(button)
        }else{
             button.frame = CGRect(x: 20, y: 10, width: self.cartTB.frame.width-50, height: 50)
            button.setTitle("الدفع", for: .normal)
             button.layer.cornerRadius = 10.0
             button.layer.borderColor = UIColor.red.cgColor
             button.layer.borderWidth = 1.0
             button.setTitleColor(UIColor.white, for: .normal)
             button.backgroundColor = UIColor.red
             button.addTarget(self, action: #selector(checkOutBtn), for: .touchUpInside)
            footerView.addSubview(button)

        }
       
       return footerView
    }
    
    
    
    @objc func checkOutBtn(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
        vc.restaurentFoodPicksVCVM = self.cartViewControllerVM.getRestaurentFoodPicksVCVM()
        vc.changedValues  = { (itemCount, index) in
            DispatchQueue.main.async {
                //   self.restarentDishViewControllerVM?.getCartCall(isFromCartScreen: true)
                //  self.restarentDishViewControllerVM?.updateCurrentCount(itemId: itemCount, itemCount: index)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
