//
//  CountryDetailViewController.swift

//"2021-07-13T00:00:00Z" need to format these dates to 07/13/2021

//https://github.com/danielgindi/Charts   Charts API

import UIKit
import Charts

class CountryDetailViewController: UIViewController, ChartViewDelegate {
        
   private let customMarkerView = CustomMarkerView() // Instance of CustomMarker
  
    static let identifier = "CountryDetailViewController"
    
    lazy var chart = LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    
    private let countryName: String
    private let isoItem: String
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CountryDetailTVCell.self, forCellReuseIdentifier: CountryDetailTVCell.identifier)
        return table
    }()
    // data for the tableView and the Chart
    var dailyDeathData: [DailyDeathData] = [] {
            didSet {
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    //self.createGraph()
                }
            }
        }
    var dailyRecoveredData: [DailyRecoveredData] = [] {
            didSet {
                DispatchQueue.main.async{
                    //self.tableView.reloadData()
                   // self.createGraph()
                }
            }
        }
    var dailyTotalData: [DailyTotalData] = [] {
            didSet {
                DispatchQueue.main.async{
                    //self.tableView.reloadData()
                    self.createGraph()
                }
            }
        }
    
    init(countryName:String, isoItem: String) {
        self.countryName = countryName
        self.isoItem = isoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getCountryData()
        view.backgroundColor = .white
        title = "\(countryName.uppercased()) Covid Deaths"
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    // try these??
//    chart.data.notifyDataChanged()
//    chart.notifyDataSetChanged()
//    chart.setNeedsDisplay()

    private func getCountryData() {
        
        APICaller.shared.getCountryDeathStatus(iso: isoItem, scope: "deaths") { [weak self] result in
            switch result {
            case .success(let dayData):
                self?.dailyDeathData = dayData  // this comes back as index, cases, date
                APICaller.shared.getCountryRecoveredStatus(iso: self?.isoItem ?? "", scope: "recovered") { [weak self] result in
                    switch result {
                    case .success(let dayRecoveredData):
                        self?.dailyRecoveredData = dayRecoveredData
                        APICaller.shared.getCountryTotalStatus(iso: self?.isoItem ?? "", scope: "confirmed") { [weak self] result in
                            switch result {
                            case .success(let dayTotalData):
                                self?.dailyTotalData = dayTotalData
                            case .failure(let error):
                                print(error.rawValue)
                            }
                        }
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print ("orientation change")
        chart.removeFromSuperview()
        chart  =  LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(chart)
        createGraph()
    }

    private func createGraph() {

    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            headerView.clipsToBounds = true
        
        let l = chart.legend
               l.horizontalAlignment = .center
               l.verticalAlignment = .top
               l.orientation = .horizontal
               l.xEntrySpace = 7
               l.yEntrySpace = 0
               l.yOffset = 5
        
        let legend = chart.legend
         legend.font = UIFont(name: "Verdana", size: 18.0)!
        
        //**************    Daily Death Data
        var entriesDeath: [ChartDataEntry] = []
        for index in 0..<dailyDeathData.count {
            let data = dailyDeathData[index]
            entriesDeath.append(ChartDataEntry(x: Double(index),y: Double(data.casesDeath)))
        }
    let set1 = LineChartDataSet(entries: entriesDeath, label: "Deaths")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.setColor(.red)
        set1.fill = Fill(color: .red)
        set1.fillAlpha = 0.8

////    //**************    Daily Recovered Data
        var entriesRecovered: [ChartDataEntry] = []
        for index in 0..<dailyRecoveredData.count {
            let data = dailyRecoveredData[index]
            entriesRecovered.append(ChartDataEntry(x: Double(index), y: Double(data.casesRecovered)))
        }
        let set2 = LineChartDataSet(entries: entriesRecovered, label: "Recovered")
        set2.mode = .cubicBezier
        set2.drawCirclesEnabled = false
        set2.lineWidth = 3
        set2.setColor(.green)
        set2.fill = Fill(color: .green)
        set2.fillAlpha = 0.8

// Daily Total or Confirmed Cases Data for Graph
        var entriesTotal: [ChartDataEntry] = []
        for index in 0..<dailyTotalData.count {
            let data = dailyTotalData[index]
            entriesTotal.append(ChartDataEntry(x: Double(index), y: Double(data.casesTotal)))
        }
        let set3 = LineChartDataSet(entries: entriesTotal, label: "Total Cases")
        set3.mode = .cubicBezier
        set3.drawCirclesEnabled = false
        set3.lineWidth = 3
        set3.setColor(.yellow)
        set3.fill = Fill(color: .yellow)
        set3.fillAlpha = 0.8

    chart.delegate = self
    chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
   
        customMarkerView.chartView = chart
    chart.marker = customMarkerView
    
    let xAxis = chart.xAxis
    xAxis.granularity = 1
    
       // chart.xAxisRenderer.axis?.enabled = false

//    // top X axis Styling
//    let f = DateFormatter()
//        f.dateStyle = .short
//    chart.xAxis.valueFormatter = DateValueFormatter(formatter: f)
        
        chart.rightYAxisRenderer.axis?.enabled = false // removes yaxis right side key
        
        let data = LineChartData(dataSet: set1)
        data.addDataSet(set2)
        data.addDataSet(set3)
        chart.data = data
        
    headerView.addSubview(chart)
    tableView.tableHeaderView = headerView
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        let entryIndex = dataSet.entryIndex(entry: entry)
      
        customMarkerView.dateLabel.text =
            formatDateForMarker(with: dailyDeathData[entryIndex].dateDeath)
        customMarkerView.deathCountLabel.text = "Deaths: \(dailyDeathData[entryIndex].casesDeath.withCommas())"
        customMarkerView.recoveredLabel.text = "Recovered: \(dailyRecoveredData[entryIndex].casesRecovered.withCommas())"
        customMarkerView.confirmedCasesLabel.text = "Confirmed: \(dailyTotalData[entryIndex].casesTotal.withCommas())"
    }
}

extension CountryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyDeathData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataDeath = dailyDeathData[indexPath.row]
        let dataRecovered = dailyRecoveredData[indexPath.row]
        let dataTotal = dailyTotalData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryDetailTVCell.identifier, for: indexPath) as! CountryDetailTVCell
      
        cell.configure(dataDeath: dataDeath, dataRecovered: dataRecovered, dataTotal: dataTotal)
//       cell.textLabel?.attributedText = makeAttributedString(title: createText(with: dataDeath, dataRecovered: dataRecovered, dataTotal: dataTotal)!)
        return cell
    }
    
    private func formatDateForMarker(with data: Date) -> String? {
        let dateString = DateFormatter.prettyFormatter.string(from: data)
        return "\(dateString)"
        }
    }

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
