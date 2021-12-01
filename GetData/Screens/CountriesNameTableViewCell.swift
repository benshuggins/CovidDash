//
//  CountriesNameTableViewCell.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
//

import UIKit

class CountriesNameTableViewCell: UITableViewCell {
    static let identifier = "CountriesTableViewCell"
    
    var itemLandingPad: Country? {
        didSet {
            updateViews()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .systemGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        label.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 20, height: contentView.frame.size.height - 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews() {
        label.text = itemLandingPad?.name
    
    }
}
