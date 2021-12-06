//
//  DeveloperMenuTableViewCell.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class DeveloperMenuTableViewCell: UITableViewCell {
    
    
       var data = String() {
           didSet{
               print("Data cell: \(data)")
           }
       }
       

    static let identifier = "DeveloperMenuTableViewCell"
    
    let uiView: UIView = {
       let uiView = UIView()
       return uiView
    }()
    
    let label: UILabel = {
       let label = UILabel()
        return label
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       // contentView.backgroundColor = .brown
        //contentView.addSubview(uiView)
      //  contentView.addSubview(label)
       
        
        contentView.layer.cornerRadius = 12
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        label.text = data
        label.frame = contentView.bounds
//        uiView.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.width-20, height: contentView.frame.size.height-25)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
