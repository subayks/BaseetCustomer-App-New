//
//  AddOnViewController.swift
//  Baseet App
//
//  Created by VinodKatta on 18/07/22.
//

import UIKit

class AddOnViewController: UIViewController {

    
    @IBOutlet weak var addonsLbl: UILabel!{
        didSet{
            addonsLbl.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "Addons", comment: "")
        }
    }
    
    @IBOutlet weak var addonTB: UITableView!
    var addOnViewControllerVM: AddOnViewControllerVM?
    var itemAdded:((Int, Int)->())?
    var addOns:(([AddOns])->())?
    var isChecked = false
    var makeCartCall:(()->())?

    @IBOutlet weak var doneBtn: UIButton!{
        didSet{
            doneBtn.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "Add To Basket", comment: ""), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
   
    @IBAction func backBtn(_ sender: Any) {
        self.makeCartCall?()
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        if isChecked {
            self.addOns?(self.addOnViewControllerVM?.addonAdded ?? [AddOns()])
        } else {
            self.makeCartCall?()
        }
        self.dismiss(animated: true,completion: nil)
    }
  
    
    
}

extension AddOnViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addOnViewControllerVM?.addOns?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddOnTableViewCell
        cell.addOnView.layer.borderColor = UIColor.white.cgColor
        cell.addOnView.layer.borderWidth = 2
        cell.buttonAdd.tag = indexPath.row
        cell.buttonCheck.tag = indexPath.row
        cell.itemAdded  = { (itemCount, index, isChecked) in
            DispatchQueue.main.async {
                if isChecked {
                    self.isChecked = isChecked
                    self.addOnViewControllerVM?.updateValues(itemCount: 1, index: index)
                } else {
                    self.addOnViewControllerVM?.updateValues(itemCount: 0, index: index)

                }
            }
        }
        cell.addOnTableViewCellVM = self.addOnViewControllerVM?.getAddOnTableViewCellVM(index: indexPath.row)
    
        return cell
    }
    
    
    
    
}
