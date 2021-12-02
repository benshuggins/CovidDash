//
//  APICaller.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
//

// FREE API I AM USING: "https://covid19api.com/"

// https://api.covid19api.com/live/country/south-africa/status/confirmed'


// Another United States Specific API with state data is (iOSAcademy): https://covidtracking.com/data

import Foundation


var index2 = 0 // added to [DayData]



class APICaller {
    
    static let shared = APICaller()
    
    struct Constant {
        static let countryNameURL = "https://api.covid19api.com/countries" //"https://api.covid19api.com/countries"
        
        // Three to query by scope (Italy)
        //https://api.covid19api.com/country/IT/status/deaths    // DEATHS
        //https://api.covid19api.com/country/IT/status/confirmed // TOTAL CASES
        //https://api.covid19api.com/country/IT/status/recovered // RECOVERED
    }
    
    private init(){   }
    
    func getCountryNames(completion: @escaping (Result<[Country], BHError>) -> Void) {
        let endPoint = Constant.countryNameURL
        
        guard let url = URL(string: endPoint) else {return}
       
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.unableToComplete))
                print(error)
            }
            else if let data = data {
                //dump(data)
                do {
                    var result = try? JSONDecoder().decode([Country].self, from: data)
                    
                    guard var resultFinal = result?.sorted() else {return}
                    
                 //   print("😜😜😜😜😜\(resultFinal)")
                    
                    resultFinal.removeAll(where: { $0.iso == "AX" || $0.iso == "AW" || $0.iso == "BL"  || $0.iso == "BM" || $0.iso == "EH" || $0.iso == "AS" || $0.iso == "AI" || $0.iso == "IO" || $0.iso == "VG" || $0.iso == "BV"})
                    
                    
                    completion(.success(resultFinal))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }
    
    // Three to query by scope (Italy)
    //https://api.covid19api.com/country/IT/status/deaths    // DEATHS
    //https://api.covid19api.com/country/IT/status/confirmed // TOTAL CASES
    //https://api.covid19api.com/country/IT/status/recovered // RECOVERED
    
    // Need to introduce scope here
    
    // pass variable into an enum???
    
    func getCountryDeathStatus(iso: String, scope: String, completion: @escaping (Result<[DailyDeathData], BHError>) -> Void ) {
        
       // https://api.covid19api.com/country/PO/status/deaths
       // https://api.covid19api.com/country/IT/status/deaths
        let baseURL = "https://api.covid19api.com/country/\(iso)/status/\(scope)"
        print("🥙🥙🥙🥙🥙🥙\(baseURL)")
        
        
        guard let url = URL(string: baseURL) else {return}
        print("🌭🌭🌭🌭🌭🌭\(url)")
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.unableToComplete))
                print(error)
            }
            
            else if let data = data {
                
                do {
                    let result = try? JSONDecoder().decode([CountryData].self, from: data)
                    
                    guard let resultOne = result else {return}
                  //  print("🥶🥶🥶🥶🥶resultOne")
                  //  print(resultOne)
                    
                    // 1 pop up an alert menu saying there is no data yet for this country
       
                    //  2 this takes country, cases, date, lat, lon data model and converts it
                    //      to just index, cases, and date that is a date object
                    
                    let models: [DailyDeathData] = resultOne.compactMap {
                        
                        guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
                        
                        // Add index to our dayData model
                        // Which is just index, case, date
                        index2 += 1
                   
                        return DailyDeathData(indexDeath: index2-1, dateDeath: date, casesDeath: $0.cases)
                    }
                   // print("👹👹👹👹👹👹Here are your viewModels: \(models)")
                    completion(.success(models))
                    
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }



func getCountryRecoveredStatus(iso: String, scope: String, completion: @escaping (Result<[DailyRecoveredData], BHError>) -> Void ) {
    
   // https://api.covid19api.com/country/IT/status/recovered
    let baseURL = "https://api.covid19api.com/country/\(iso)/status/recovered"
    print("🥙🥙🥙🥙🥙🥙\(baseURL)")
    
    guard let url = URL(string: baseURL) else {return}
    print("🌭🌭🌭🌭🌭🌭\(url)")
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(.failure(.unableToComplete))
            print(error)
        }
        else if let data = data {
            
            do {
                let result = try? JSONDecoder().decode([CountryData].self, from: data)
                
                guard let resultOne = result else {return}
               // print("🥶🥶🥶🥶🥶resultOne")
             //   print(resultOne)
                
                // 1 pop up an alert menu saying there is no data yet for this country
   
                //  2 this takes country, cases, date, lat, lon data model and converts it
                //      to just index, cases, and date that is a date object
                
                let modelsRecovered: [DailyRecoveredData] = resultOne.compactMap {
                    
                    guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
                    
                    // Add index to our dayData model
                    // Which is just index, case, date
                    index2 += 1
               
                    return DailyRecoveredData(indexRecovered: index2-1, dateRecovered: date, casesRecovered: $0.cases)
                }
               // print("👹👹👹👹👹👹Here are your viewModels: \(models)")
                completion(.success(modelsRecovered))
                
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    task.resume()
}



func getCountryTotalStatus(iso: String, scope: String, completion: @escaping (Result<[DailyTotalData], BHError>) -> Void ) {
    
   // https://api.covid19api.com/country/IT/status/recovered
    let baseURL = "https://api.covid19api.com/country/\(iso)/status/confirmed"
    print("🥙🥙🥙🥙🥙🥙\(baseURL)")
    
    guard let url = URL(string: baseURL) else {return}
    print("🌭🌭🌭🌭🌭🌭\(url)")
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(.failure(.unableToComplete))
            print(error)
        }
        else if let data = data {
            
            do {
                let result = try? JSONDecoder().decode([CountryData].self, from: data)
                
                guard let resultOne = result else {return}
                print("🥶🥶🥶🥶🥶resultOne")
                print(resultOne)
                
                // 1 pop up an alert menu saying there is no data yet for this country
   
                //  2 this takes country, cases, date, lat, lon data model and converts it
                //      to just index, cases, and date that is a date object
                
                let modelsTotal: [DailyTotalData] = resultOne.compactMap {
                    
                    guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
                    
                    // Add index to our dayData model
                    // Which is just index, case, date
                    index2 += 1
               
                    return DailyTotalData(indexTotal: index2-1, dateTotal: date, casesTotal: $0.cases)
                }
                print("👹👹👹👹👹👹Here are your viewModels: \(modelsTotal)")
                completion(.success(modelsTotal))
                
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    task.resume()
}

}
//2021-07-12T00:00:00Z
// First Model
struct Country: Codable, Comparable, Hashable {
   
    let name: String
    let iso: String
    
    static func < (lhs: Country, rhs: Country) -> Bool {
        return lhs.iso < rhs.iso
    }
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.iso == rhs.iso
    }
    
    enum CodingKeys: String, CodingKey {
            case name = "Country"
            case iso = "ISO2"
   
    }
}


// Second Model
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

// This is a ViewModel for the  death Graph and marker View uses it as well
struct DailyDeathData: Codable {
    let indexDeath: Int
    let dateDeath: Date
    let casesDeath: Int//?
}

struct DailyRecoveredData: Codable {
    let indexRecovered: Int
    let dateRecovered: Date
    let casesRecovered: Int//?
}

struct DailyTotalData: Codable {
    let indexTotal: Int
    let dateTotal: Date
    let casesTotal: Int//?
}


// this converts from string to a date object
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"  //"YYYY-MM-dd" //"yyyy-MM-dd'T'HH:mm:SSZ"
        formatter.timeZone = .none
        formatter.locale = .none
        return formatter
    }()
    
    static let prettyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.timeZone = .none
        formatter.locale = .none
        return formatter
    }()
}


