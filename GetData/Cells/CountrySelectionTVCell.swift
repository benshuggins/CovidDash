//
//  CountriesNameTableViewCell.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
//

import UIKit

class CountrySelectionTVCell: UITableViewCell {
    static let identifier = "CountriesTableViewCell"
    
    var itemLandingPad: Country? {
        didSet {
            updateViews()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .systemGray
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        label.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 40, height: contentView.frame.size.height - 20)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews() {
        label.text = itemLandingPad?.name
    }
}
