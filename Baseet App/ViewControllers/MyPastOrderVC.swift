//
//  MyPastOrderVC.swift
//  Baseet App
//
//  Created by VinodKatta on 15/07/22.
//

import UIKit

class MyPastOrderVC: UIViewController {
    @IBOutlet weak var mypastOrderTB: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   

}

extension MyPastOrderVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyPastOrderTableViewCell
        return cell
    }
    
    
    
    
}
