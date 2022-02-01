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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CountryDetailTVCell.identifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(recoveredLabel)
        contentView.addSubview(deathLabel)
        configureDateLabel()
        configureTotalCasesLabel()
        configureRocoveredCasesLabel()
        configureDeathLabel()
        setDateLabelConstraints()
        setTotalLabelConstraints()
        setRecoveredLabelConstraints()
        setDeathLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func configureDateLabel() {
        dateLabel.textColor = .black
      //  dateLabel.backgroundColor = .white
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
   private func configureTotalCasesLabel() {
        totalLabel.textColor = .black
        //totalLabel.backgroundColor = .white
        totalLabel.adjustsFontSizeToFitWidth = true
    }
    
   private func configureRocoveredCasesLabel() {
        recoveredLabel.textColor = .black
      //  recoveredLabel.backgroundColor = .white
        recoveredLabel.adjustsFontSizeToFitWidth = true
    }
    
   private func configureDeathLabel() {
        deathLabel.textColor = .black
       // deathLabel.backgroundColor = .white
        deathLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func setDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints =                               false
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive =               true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive =                   true
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive =                   true
    }
    
    private func setTotalLabelConstraints() {
        totalLabel.translatesAutoresizingMaskIntoConstraints =                                  false
        totalLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive =       true
        totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 30).isActive =                      true
        totalLabel.topAnchor.constraint(equalTo: topAnchor).isActive =                          true
    }
    
    private func setRecoveredLabelConstraints() {
        recoveredLabel.translatesAutoresizingMaskIntoConstraints =                                  false
        recoveredLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive =       true
        recoveredLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor).isActive =            true
        recoveredLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        recoveredLabel.heightAnchor.constraint(equalToConstant: 30).isActive =                      true
    }
    
    private func setDeathLabelConstraints() {
        deathLabel.translatesAutoresizingMaskIntoConstraints =                                  false
        deathLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor).isActive =      true
        deathLabel.topAnchor.constraint(equalTo: recoveredLabel.bottomAnchor).isActive =        true
        deathLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        deathLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive =                    true
    }
    
    func configure(dataDeath: DailyDeathData, dataRecovered: DailyRecoveredData, dataTotal: DailyTotalData) {
        let cellText = createText(with: dataDeath, dataRecovered: dataRecovered, dataTotal: dataTotal)
        dateLabel.attributedText = makeAttributedString(title: cellText?.first ?? "N/A")
        totalLabel.attributedText = makeAttributedString(title: cellText?[3] ?? "N/A")
        recoveredLabel.attributedText = makeAttributedString(title: cellText?[2] ?? "N/A")
        deathLabel.attributedText = makeAttributedString(title: cellText?[1] ?? "N/A")
    }
    
   func createText(with dataDeath: DailyDeathData, dataRecovered: DailyRecoveredData, dataTotal: DailyTotalData) -> [String]? {                       
        let dateString = DateFormatter.prettyFormatter.string(from: dataDeath.dateDeath)
        return ["  \(dateString):"," Deaths: \(dataDeath.casesDeath.withCommas())"," Recovered: \(dataRecovered.casesRecovered.withCommas())"," Confirmed Cases: \(dataTotal.casesTotal.withCommas())"]
    }
    
 func makeAttributedString(title: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline), NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
            return titleString
            }
}


