//
//  DeveloperMenuVC.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class TableHeaderDev: UITableViewHeaderFooterView, UITableViewDelegate {
    
    static let identifier = "TableHeaderDev"
    
    private let imageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "benImage")
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
        
        imageView.frame = CGRect(x: 0, y: 40, width: contentView.frame.size.width, height: contentView.frame.size.height-15-label.frame.size.height+180)
    }
}


class DeveloperMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    static let developerMenuVC = DeveloperMenuVC()
    
    let data = ["LinkedIn", "Github", "Contact", "Github"]
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(DeveloperMenuTableViewCell.self, forCellReuseIdentifier: DeveloperMenuTableViewCell.identifier)
        table.register(TableHeaderDev.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Developer"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DeveloperMenuTableViewCell.identifier) as! DeveloperMenuTableViewCell
        let data1 = data[indexPath.row]
        cell.data = data1
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TableHeaderDev
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }


}
