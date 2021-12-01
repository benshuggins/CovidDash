//
//  CustomMarkerView.swift
//  GetData
//
//  Created by Ben Huggins on 9/9/21.
//


import Charts
import UIKit

class CustomMarkerView: MarkerView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var deathCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var confirmedCasesLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    private func initUI() {
        Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .systemRed
        
        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.offset = CGPoint(x: -(self.frame.width/2+150), y: -self.frame.height-200)
    }
    
    
}
