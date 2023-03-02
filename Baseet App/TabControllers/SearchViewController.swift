//
//  SearchViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 08/07/22.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet weak var searchCV: UICollectionView!
    @IBOutlet weak var searchTF: SearchTextField!
    @IBOutlet weak var searchSL: UISearchBar!
    @IBOutlet weak var mostsearchedL: UILabel!
    @IBOutlet weak var searchRestLblL: UILabel!
    @IBOutlet weak var nearByLblL: UILabel!
    var restaurantsArray = [String]()
    var productsArray = [String]()
    
    @IBOutlet weak var popularResCV: UICollectionView!
    var searchBarVM = SearchBarVM()
    let searchNamesArray = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "Biryani", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Mandi", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Pizza", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Burger", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Sawarma", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "Rumali", comment: ""),
                            LocalizationSystem.sharedInstance.localizedStringForKey(key: "pasta", comment: "")]

    let searchimageArray = [
    UIImage(named: "1"),
    UIImage(named: "2"),
    UIImage(named: "3"),
    UIImage(named: "4"),
    UIImage(named: "5"),
    UIImage(named: "6"),
    UIImage(named: "7"),
    UIImage(named: "8"),
    UIImage(named: "9"),
    UIImage(named: "10"),
    UIImage(named: "11")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        mostsearchedL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Most Searched and Bought", comment: "")
        searchRestLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search For Restaurents", comment: "")
        nearByLblL.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Near by Popular Restaurents", comment: "")
        searchSL.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Search for Restaurents,Item's & Food", comment: "")
         
        searchCV.reloadData()
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.gray, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 5.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBarVM.reloadClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.popularResCV.reloadData()
            }
        }
        
        self.searchBarVM.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showLoadingView()
            }
        }
        
        self.searchBarVM.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.hideLoadingView()
            }
        }
        
        self.searchBarVM.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.searchBarVM.navigateToDetailsClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RestarentDishViewController") as! RestarentDishViewController
                // vc.modalTransitionStyle = .coverVertical
                vc.restarentDishViewControllerVM = self.searchBarVM.getRestarentDishViewControllerVM()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        if self.searchBarVM.iconArray.count == 0 {
        self.searchBarVM.makeShopNearyByCall()
        }
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchRestaurentVC") as! SearchRestaurentVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func searchNames(){
        let token = UserDefaults.standard.string(forKey: "zoneID")
        let headers : HTTPHeaders = [
            "zoneId": "\(token!)"
        ]
        print(headers)
        AF.request("\(Constants.Common.finalURL)/restaurants/search?name=\(searchTF.text!)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: headers)
            .responseJSON { [self] response in
                    switch response.result {
                    case .success(let json):
                        print(json)
                        let response = json as! [String:AnyObject]
                        self.restaurantsArray.removeAll()
                        self.productsArray.removeAll()
                       /* guard let message = response["errors"] as? [String:AnyObject] else{
                            return
                        }*/
                        DispatchQueue.main.async {
                            let restaurants = response["restaurants"] as? Array<Any>
                            if restaurants?.count == 0{
                                print("restaurants Empty")
                                restaruantItems = "EmptyRestaurants"
                            }else{
                                for i in 0 ..< (restaurants?.count ?? 0){
                                    let x = restaurants![i] as! [String:AnyObject]
                                    let name = x["name"] as? String ?? ""
                                    self.restaurantsArray.append(name)
                                }
                            }
                            
                            let products = response["products"] as? Array<Any>
                            if products?.count == 0{
                                print("Products Empty")
                                productItems = "EmptyProducts"
                            }else{
                                for i in 0 ..< (products?.count ?? 0){
                                    let x = products![i] as! [String:AnyObject]
                                    let name = x["name"] as? String ?? ""
                                    self.productsArray.append(name)
                                }
                            }
                            
                            self.restaurantsArray.append(contentsOf: self.productsArray)
                        }
                        
                    case .failure(let error):
                        print(error)
                       /* let alert = UIAlertController(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Baseet-Driver", comment: ""), message: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Unable To Connect Server", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: LocalizationSystem.sharedInstance.localizedStringForKey(key: "Okay", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)*/
                    }
            }
    }

}

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.searchCV
           {
               return 7
           }

        return self.searchBarVM.iconArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        
        
        if collectionView == self.searchCV {
            let cellA = searchCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
            
            cellA.itemLbl.text = searchNamesArray[indexPath.row]

                // ...Set up cell
                return cellA
            }

            else {
                let cellB = popularResCV.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PopularResCollectionViewCell
                cellB.restpopularImage.loadImageUsingURL(self.searchBarVM.iconArray[indexPath.row])
                cellB.restpopularImage.layer.cornerRadius = 5
                return cellB
            }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.popularResCV {
            guard let id = self.searchBarVM.shopListModel?.restaurants?[indexPath.row].id else { return }
            self.searchBarVM.makeShopDetailsCall(id: id)
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SearchRestaurentVC") as! SearchRestaurentVC
            vc.modalPresentationStyle = .fullScreen
            vc.query = searchNamesArray[indexPath.row]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let xPadding = 10
//            let spacing = 10
//            let rightPadding = 10
//            let width = (CGFloat(UIScreen.main.bounds.size.width) - CGFloat(xPadding + spacing + rightPadding))/4
//            let height = CGFloat(215)
//
//            return CGSize(width: width, height: height)
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//           return 10
//       }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let noOfCellsInRow = 4
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((popularResCV.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 130)

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//           let padding: CGFloat =  50
//           let collectionViewSize = collectionView.frame.size.width - padding
//
//           return CGSize(width: collectionViewSize/4, height: collectionViewSize/2)
//       }
}

extension SearchViewController:UITextFieldDelegate
{
    fileprivate func configureSimpleSearchTextField() {
        if searchTF.text!.count > 2{
            searchTF.startVisibleWithoutInteraction = true
            searchTF.filterStrings(restaurantsArray)
            print(restaurantsArray)
        }
       }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.searchTF{
            searchNames()
            configureSimpleSearchTextField()
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchRestaurentVC") as! SearchRestaurentVC
        // vc.modalTransitionStyle = .coverVertical
      //  vc.restarentDishViewControllerVM = self.homeViewControllerVM.getRestarentDishViewControllerVM()
        vc.modalPresentationStyle = .fullScreen
        vc.searchingField = searchTF.text!
        self.present(vc, animated: true, completion: nil)
    }
}
