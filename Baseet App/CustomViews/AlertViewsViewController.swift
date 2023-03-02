//
//  AlertViewsViewController.swift
//  Baseet App
//
//  Created by apple on 17/11/22.
//

import UIKit

class AlertViewsViewController: UIViewController {
    
    @IBOutlet weak var couponlbl: UILabel!
    
    init(){
        super.init(nibName: "AlertViewsViewController.swift", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

 override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
       
     
        
    }


 
    
}
