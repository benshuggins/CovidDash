//
//  DailyDeathData.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/6/21.
//

import Foundation

// This is a ViewModel for the  death Graph and marker View uses it as well
struct DailyDeathData: Codable {
    let indexDeath: Int
    let dateDeath: Date
    let casesDeath: Int//?
}
