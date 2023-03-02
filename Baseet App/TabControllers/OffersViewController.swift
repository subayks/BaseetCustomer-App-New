//
//  OffersViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit

class OffersViewController: UIViewController {

    @IBOutlet weak var bgVieww: UIView!
    @IBOutlet weak var offersforu: UILabel!
    @IBOutlet weak var noCouponsLbl: UILabel!
    @IBOutlet weak var offersTopLbl: UILabel!
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    var offersViewVM = OffersViewVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersforu.text   = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Offers for You", comment: "")
       // noCouponsLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "No Coupons Available", comment: "")
        offersTopLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Offers", comment: "")
        
        
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == false
        {
            bgVieww.isHidden = true
            offersforu.isHidden = true
            offersTableView.isHidden = true
            let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
            vc!.modalPresentationStyle = .fullScreen
            isfromoffers = "isfromOffersList"
            self.present(vc!, animated: true, completion: nil)
        }else{
            bgVieww.isHidden = false
            offersforu.isHidden = false
            offersTableView.isHidden = false
            self.offersViewVM.reloadClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.offersTableView.reloadData()
                }
            }
            
            self.offersViewVM.showLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.showLoadingView()
                }
            }
            
            self.offersViewVM.hideLoadingIndicatorClosure = { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    self.hideLoadingView()
                }
            }
            
            self.offersViewVM.alertClosure = { [weak self] (error) in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            self.offersViewVM.makeCouponListCall()
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

extension OffersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offersViewVM.couponModel?.data?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.offersViewVM.couponModel?.data?.count == 0 ||  self.offersViewVM.couponModel?.data?.count  == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoCoupsAvailableCell", for: indexPath) as! NoCoupsAvailableCell
            cell.noCouponLable.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "No Coupons Available", comment: "")
            
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        cell.CouponCellVM = self.offersViewVM.getCouponCellVM(index: indexPath.row)
        return cell
        }
    }
    
}
