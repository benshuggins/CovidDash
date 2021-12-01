//
//  CountryDetailViewController.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
//

//"2021-07-13T00:00:00Z" need to format these dates to 07/13/2021

//https://github.com/danielgindi/Charts   Charts API

import UIKit
import Charts

final class DateValueFormatter: IAxisValueFormatter {

    // this is adjustable, we want give value return date
//
//    let months = ["Jan", "Feb", "Mar",
//                  "Apr", "May", "Jun",
//                  "Jul", "Aug", "Sep",
//                  "Oct", "Nov", "Dec"]
////
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//   // return String(value+21)//formatter.string(from: Date(timeIntervalSinceReferenceDate: value))
//    return months[Int(value) % months.count]
//  }
    
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
//    init(chart: BarLineChartViewBase) {
//        self.chart = chart
//    }

  let formatter: DateFormatter

  init(formatter: DateFormatter) {
    self.formatter = formatter
  }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let days = Int(value)
        let year = determineYear(forDays: days)
        let month = determineMonth(forDayOfYear: days)
        
        let monthName = months[month % months.count]
        let yearName = "\(year)"
        
        if let chart = chart,
            chart.visibleXRange > 30 * 6 {
            return monthName + yearName
        } else {
            let dayOfMonth = determineDayOfMonth(forDays: days, month: month + 12 * (year - 2016))
            var appendix: String
            
            switch dayOfMonth {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }
            
            return dayOfMonth == 0 ? "" : String(format: "%d\(appendix) \(monthName)", dayOfMonth)
        }
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
        // month is 0-based
        switch month {
        case 1:
            var is29Feb = false
            if year < 1582 {
                is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
            } else if year > 1582 {
                is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
            }
            
            return is29Feb ? 29 : 28
            
        case 3, 5, 8, 10:
            return 30
            
        default:
            return 31
        }
    }
    
    private func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            month += 1
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
        }
        
        return max(month, 0)
    }
    
    private func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = determineYear(forDays: days)
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
    private func determineYear(forDays days: Int) -> Int {
        switch days {
        case ...366: return 2020
        case 367...730: return 2021
        case 731...1094: return 2022
        case 1095...1458: return 2023
        default: return 2020
        }
    }
}



class CountryDetailViewController: UIViewController, ChartViewDelegate {
        
    let customMarkerView = CustomMarkerView() // Instance of CustomMarker
  
    static let identifier = "CountryDetailViewController"
    
    lazy var chart = LineChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    
    private let countryName: String
    private let isoItem: String
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
                    self.createGraph()
                }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getCountryDeaths()
        view.backgroundColor = .white
        title = "\(countryName.uppercased()) Covid Deaths"
    }
    
    func configureTableView() {
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
    
    
    // can I call create graph with a single line?????
    func getCountryDeaths() {
        
        APICaller.shared.getCountryStatus(iso: isoItem, scope: "deaths") { [weak self] result in
            switch result {
            case .success(let dayData):
//                print("🍟🍟🍟🍟🍟")
//                print(dayData)
                // this comes back as index, cases, date
                self?.dailyDeathData = dayData
                // call the next api call
               // self?.getCountryRecovered()
            
                APICaller.shared.getCountryRecoveredStatus(iso: self?.isoItem ?? "", scope: "recovered") { [weak self] result in
                    switch result {
                    case .success(let dayRecoveredData):
                        
//                        print("😘😘😘😘😘😘😘")
//                        print(dayRecoveredData)
                        self?.dailyRecoveredData = dayRecoveredData
                        
                    
                        
                        
                    case .failure(let error):
                        print(error.rawValue)
                    }
                    
                }
            
            
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
   
    
 // let me = Set([1,1])
        
    
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
    
    // This builds an entry which is used for the Bar Chart the Bar Chart can only except (x axis: index Double value, y - axis Double value). However dayData1 should also contain the corresponding index. This is for the Marker. A funtion called

    
    
        
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


        
        
        
    chart.delegate = self
    chart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
   
        customMarkerView.chartView = chart
    chart.marker = customMarkerView
    
    let xAxis = chart.xAxis
    xAxis.granularity = 1

    // top X axis Styling
    let f = DateFormatter()
        f.dateStyle = .short
    chart.xAxis.valueFormatter = DateValueFormatter(formatter: f)
        
        
        let data = LineChartData(dataSet: set1)
        
        data.addDataSet(set2)
        
       // data.addDataSet(set3)
        
        
   // chart.data = dataDeath    // < == here is where we add to the graph //  data.addDataSet(set2)
     
        chart.data = data
        
    headerView.addSubview(chart)
    tableView.tableHeaderView = headerView
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        let entryIndex = dataSet.entryIndex(entry: entry)
      
        customMarkerView.dateLabel.text =
            formatDateForMarker(with: dailyDeathData[entryIndex].dateDeath)

        customMarkerView.deathCountLabel.text = "Deaths: \(dailyDeathData[entryIndex].casesDeath)"
        
        customMarkerView.recoveredLabel.text = "Recovered: \(dailyRecoveredData[entryIndex].casesRecovered)"
    }
//    func getCountryRecovered() {
//        APICaller.shared.getCountryStatus(iso: isoItem) { [weak self] result in
//            switch result {
//            case .success(let dayData):
//                print("🍟🍟🍟🍟🍟")
//                print(dayData)
//                // this comes back as index, cases, date
//              //  self?.dailyRecoveredData = dayData
//                // call the next api call
//                self?.getCountryRecovered()
//            case .failure(let error):
//                print(error.rawValue)
//            }
//        }
//
//
//    }
    init(countryName:String, isoItem: String) {
        self.countryName = countryName
        self.isoItem = isoItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CountryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyDeathData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dailyDeathData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = createText(with: data)
        return cell
    }
    
    private func createText(with data: DailyDeathData) -> String? {                       // return a tuple here
        let dateString = DateFormatter.prettyFormatter.string(from: data.dateDeath)
        return "\(dateString),           Deaths:  \(data.casesDeath)"
    }
    
    private func formatDateForMarker(with data: Date) -> String? {
        let dateString = DateFormatter.prettyFormatter.string(from: data)
        return "\(dateString)"
    }
}




//        //**************    Daily Death Data 2nd copy
//
//        var entriesDeath: [BarChartDataEntry] = []
//        for index in 0..<dailyDeathData.count {
//            let data = dailyDeathData[index]
//            entriesDeath.append(.init(x: Double(index),y: Double(data.casesDeath)))
//        }
//    let dataSetDeath = BarChartDataSet(entries: entriesDeath, label: "Deaths")
//
//  //      let set1 = LineChartDataSet(entries: deathEntries, label: "Deaths")
//
//
//        dataSetDeath.setColor(.red)
//    //dataSet.colors = ChartColorTemplates.joyful()
//
//    let dataDeath: BarChartData = BarChartData(dataSet: dataSetDeath)
//
//   // let set1 = LineChartDataSet(entries: deathEntries, label: "Deaths")
//
//    //************** END OF THE SECOND COPY
