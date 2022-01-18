//
//  CountryDetailTVCell.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/23/21.


import UIKit

class CountryDetailTVCell: UITableViewCell {
    
    static let identifier = "CountryDetailTVCell"
    
    let dateLabel = UILabel()
    
    let totalLabel = UILabel()
    
    let recoveredLabel = UILabel()
    
    let deathLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = CGRect(x: 0, y: 0, width: 100, height: contentView.frame.size.height)
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10))
        
        totalLabel.frame = CGRect(x: 100, y: 0, width: 300, height: 30)
        recoveredLabel.frame = CGRect(x: 100, y: 30, width: 300, height: 30)
        deathLabel.frame = CGRect(x: 100, y: 60, width: 300, height: 30)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CountryDetailTVCell.identifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(recoveredLabel)
        contentView.addSubview(deathLabel)
        //contentView.backgroundColor = .systemGray
        
        
        // add shadow on cell
           // backgroundColor = .clear // very important
           // layer.masksToBounds = false
            dateLabel.textColor = .black
            dateLabel.backgroundColor = .white
            dateLabel.layer.cornerRadius = 8
            
        
        totalLabel.textColor = .black
        totalLabel.backgroundColor = .white
        
        recoveredLabel.textColor = .black
        recoveredLabel.backgroundColor = .white
        
        deathLabel.textColor = .black
        deathLabel.backgroundColor = .white
        
    }
    
   
    //       cell.textLabel?.attributedText = makeAttributedString(title: createText(with: dataDeath, dataRecovered: dataRecovered, dataTotal: dataTotal)!)
    
    func configure(dataDeath: DailyDeathData, dataRecovered: DailyRecoveredData, dataTotal: DailyTotalData) {
        
        let cellText = createText(with: dataDeath, dataRecovered: dataRecovered, dataTotal: dataTotal)
    
        dateLabel.attributedText = makeAttributedString(title: cellText?.first ?? "N/A")
        totalLabel.attributedText = makeAttributedString(title: cellText?[3] ?? "N/A")
        recoveredLabel.attributedText = makeAttributedString(title: cellText?[2] ?? "N/A")
        deathLabel.attributedText = makeAttributedString(title: cellText?[1] ?? "N/A")
       
    }
    
    private func createText(with dataDeath: DailyDeathData, dataRecovered: DailyRecoveredData, dataTotal: DailyTotalData) -> [String]? {                       
        let dateString = DateFormatter.prettyFormatter.string(from: dataDeath.dateDeath)
        return ["  \(dateString):"," Deaths: \(dataDeath.casesDeath.withCommas())"," Recovered: \(dataRecovered.casesRecovered.withCommas())"," Confirmed Cases: \(dataTotal.casesTotal.withCommas())"]
    }
    
    private func makeAttributedString(title: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
            return titleString
            }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


