//
//  MyFavoritesViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 13/07/22.
//

import UIKit

class MyFavoritesViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var myFevTB: UITableView!
    var myFavVM = MyFavoritesVM()
    @IBOutlet weak var myFevL: UILabel!
    @IBOutlet weak var currentlyNoFevL: UILabel!
    
    @IBOutlet weak var CurNoFavAddL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        myFevL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "myFev", comment: "")
        
        self.setupNavigationBar()
        self.myFavVM.wishListCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myFavVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.myFevTB.reloadData()
            }
        }
        
        self.myFavVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.myFavVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.myFavVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.myFavVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.myFavVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionOrderNow(_ sender: UIButton) {
        guard let id = self.myFavVM.favModel?.restaurant?[sender.tag].id else { return }
        self.myFavVM.makeShopDetailsCall(id: id)
    }
    
    @IBAction func myFevBack(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func actionFav(_ sender: UIButton) {
        guard let id = self.myFavVM.favModel?.restaurant?[sender.tag].id else { return }
        self.myFavVM.removeFavouriteCall(id: id)
    }
    
    func setupNavigationBar() {
        self.userName.text = UserDefaults.standard.string(forKey: "Name") ?? "Unknown"
    }
    
}

extension MyFavoritesViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myFavVM.favModel?.restaurant?.count == 0 ? 1: self.myFavVM.favModel?.restaurant?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.myFavVM.favModel?.restaurant?.count == 0 ||  self.myFavVM.favModel?.restaurant?.count == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyFavCell", for: indexPath) as! EmptyFavCell
            cell.currentNoFev.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "currentNoFev", comment: "")
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyFevTableViewCell
        cell.myFevTableViewCellVM = self.myFavVM.getMyFevTableViewCellVM(index: indexPath.row)
        cell.orderNowButton.tag = indexPath.row
        cell.buttonFav.tag = indexPath.row
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = self.myFavVM.favModel?.restaurant?[indexPath.row].id else { return }
        self.myFavVM.makeShopDetailsCall(id: id)
    }
}
