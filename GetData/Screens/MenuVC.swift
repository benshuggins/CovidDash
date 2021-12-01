//
//  MenuVC.swift
//  GetData
//
//  Created by Ben Huggins on 7/22/21.
//

import UIKit

class MenuVC: UIViewController {
    
    static let menuVC = MenuVC()
    
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.addSubview(tableView)
    }
    
    
    
}
