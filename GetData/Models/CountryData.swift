//
//  CountryData.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/6/21.
//

// This is the second DataModel it returns Confirmed, Recovered, and Deaths for a given country

// The next three viewModels used for the three line graghs (Total Cases, Recovered Cases, Deaths Cases) are constructed using this model. 

import Foundation

struct CountryData: Codable {
    let country: String
    let cases: Int
    let date: String
    let lat: String
    let lon: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
            case country = "Country"
            case cases = "Cases"
            case date = "Date"
            case lat = "Lat"
            case lon = "Lon"
            case status = "Status"
    }
}
