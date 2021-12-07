//
//  DailyRecoveredData.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/6/21.
//

import Foundation

struct DailyRecoveredData: Codable {
    let indexRecovered: Int
    let dateRecovered: Date
    let casesRecovered: Int//?
}
