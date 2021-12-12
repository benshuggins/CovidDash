//  DailyTotalData.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/6/21.
//
// This is a ViewModel for the Total Cases Graph and marker View uses it as well. It is derived from the CountryData Model (submodel).

import Foundation

struct DailyTotalData: Codable {
    let indexTotal: Int
    let dateTotal: Date
    let casesTotal: Int//?
}
