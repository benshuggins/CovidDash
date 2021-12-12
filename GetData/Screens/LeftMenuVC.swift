//
//  DeveloperMenuVC.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class LeftTableHeaderCell: UITableViewHeaderFooterView, UITableViewDelegate {
    
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



class LeftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   
    static let developerMenuVC = LeftMenuVC()
    let data = ["Get Code: Github", "API Used: Covid19api.com", "Contact", "Github"]
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(LeftMenuTVCell.self, forCellReuseIdentifier: LeftMenuTVCell.identifier)
        table.register(LeftTableHeaderCell.self, forHeaderFooterViewReuseIdentifier: "header")
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
        let cellData = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTVCell.identifier) as! LeftMenuTVCell
        //cell.configure(with: "Cell #: \(indexPath.row)")
        cell.data = cellData
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? LeftTableHeaderCell
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

extension LeftMenuVC: LeftMenuButtonActionDelegate {
    func didTapButton(data: String) {
        print("Did recieve button tap from: \(data) ")
    }
}
