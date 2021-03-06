//
//  MenuVCTableViewCell.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class RightMenuTVCell: UITableViewCell {
    
    static let identifier = "RightMenuVCTableViewCell"
    
  
    
    let cellTitleLabel = UILabel()
    
     var iconImageView = UIImageView()
    
    let uiView: UIView = {
       let uiView = UIView()
       return uiView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray
        contentView.layer.cornerRadius = 12
        contentView.addSubview(uiView)
        contentView.addSubview(cellTitleLabel)
        cellTitleLabel.frame = CGRect(x: 10, y: 10, width: 100, height: 40)
        iconImageView.frame = CGRect(x: 120, y: 10, width: 100, height: 40)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        uiView.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.width-20, height: contentView.frame.size.height-20)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

