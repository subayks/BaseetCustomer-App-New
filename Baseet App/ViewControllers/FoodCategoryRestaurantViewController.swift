//
//  FoodCategoryRestaurantViewController.swift
//  Baseet App
//
//  Created by apple on 28/02/23.
//

import UIKit
import Alamofire

class FoodCategoryRestaurantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var resTblVieww: UITableView!
    
    var FoodCategoryModel = FoodCategoryVM()
    
    var categoryID:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backBtn.addTarget(self, action: #selector(backHome), for: .touchUpInside)
        self.resTblVieww.delegate = self
        self.resTblVieww.dataSource = self
        FoodCategoryModel.categoryID = categoryID
        FoodCategoryModel.getRestaurants()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.FoodCategoryModel.reloadtabRestaurantloader = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.resTblVieww.reloadData()
            }
        }
        
        self.FoodCategoryModel.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.FoodCategoryModel.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        self.FoodCategoryModel.navigateToCartClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestaurentFoodPicksVC") as! RestaurentFoodPicksVC
                vc.restaurentFoodPicksVCVM = self.FoodCategoryModel.getRestaurentFoodPicksVCVM()
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
    }
    
    @objc func backHome(){
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FoodCategoryModel.categoryRestaurantNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resTblVieww.dequeueReusableCell(withIdentifier: "RestaurentCell") as! RestaurentCell
        cell.bannerImage.downloaded(from: self.FoodCategoryModel.imageArary[indexPath.row])
        cell.hotelLogo.downloaded(from: self.FoodCategoryModel.applogoArray[indexPath.row])
        cell.ratingButton.setTitle("\(self.FoodCategoryModel.ratingArray[indexPath.row])", for: .normal)
        cell.salonName.text = self.FoodCategoryModel.categoryRestaurantNameArray[indexPath.row]
        cell.timingButton.setTitle(self.FoodCategoryModel.deliveryTimeArray[indexPath.row], for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.FoodCategoryModel.makeShopDetailsCall(id: self.FoodCategoryModel.categoryIDArray[indexPath.row])
    }
    
    
}
