//
//  MenuVC.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class RightTableHeaderCell: UITableViewHeaderFooterView, UITableViewDelegate {
  
    static let identifier = "TableHeader"
    
    private let imageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "apiImage")
      return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Api Used:"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        //contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: contentView.frame.size.height-10-label.frame.size.height, width: contentView.frame.size.width, height: contentView.frame.size.height)
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height-15-label.frame.size.height+200)
    }
}

class RightMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    static let menuVC = RightMenuVC()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(RightMenuTVCell.self, forCellReuseIdentifier: RightMenuTVCell.identifier)
        table.register(RightTableHeaderCell.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        self.tableView.layer.cornerRadius = 9
        self.tableView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RightMenuTVCell.identifier, for: indexPath) as? RightMenuTVCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? RightTableHeaderCell
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}


