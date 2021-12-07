//
//  DailyTotalData.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/6/21.
//

import Foundation

// This viewModel is used for the Graph and for the custom floating marker View

struct DailyTotalData: Codable {
    let indexTotal: Int
    let dateTotal: Date
    let casesTotal: Int//?
}
