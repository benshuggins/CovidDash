//
//  APICaller.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
// FREE API I AM USING: "https://covid19api.com/" here is anther free covid api ios academy used: //  https://covidtracking.com/data

// Three to query by scope (Italy)
//https://api.covid19api.com/country/IT/status/deaths    // DEATHS
//https://api.covid19api.com/country/IT/status/confirmed // TOTAL CASES
//https://api.covid19api.com/country/IT/status/recovered // RECOVERED

import Foundation

var index2 = 0

class APICaller {
    
    static let shared = APICaller()
    struct Constant {
    static let countryNameURL = "https://api.covid19api.com/countries" }
     
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
                    resultFinal.removeAll(where: { $0.iso == "AX" || $0.iso == "AW" || $0.iso == "BL"  || $0.iso == "BM" || $0.iso == "EH" || $0.iso == "AS" || $0.iso == "AI" || $0.iso == "IO" || $0.iso == "VG" || $0.iso == "BV"})
                    
                    completion(.success(resultFinal))
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }
    
    func getCountryDeathStatus(iso: String, scope: String, completion: @escaping (Result<[DailyDeathData], BHError>) -> Void ) {
        let baseURL = "https://api.covid19api.com/country/\(iso)/status/\(scope)"
        guard let url = URL(string: baseURL) else {return}

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(.unableToComplete))
                print(error)
            }
            
            else if let data = data {
                
                do {
                    let result = try? JSONDecoder().decode([CountryData].self, from: data)
                    guard let resultOne = result else {return}
                    let models: [DailyDeathData] = resultOne.compactMap {
                        
            guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
                        index2 += 1
                   
                        return DailyDeathData(indexDeath: index2-1, dateDeath: date, casesDeath: $0.cases)
                    }
                    completion(.success(models))
                    
                } catch {
                    completion(.failure(.invalidData))
                }
            }
        }
        task.resume()
    }

func getCountryRecoveredStatus(iso: String, scope: String, completion: @escaping (Result<[DailyRecoveredData], BHError>) -> Void ) {
 
    let baseURL = "https://api.covid19api.com/country/\(iso)/status/recovered"

    guard let url = URL(string: baseURL) else {return}
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(.failure(.unableToComplete))
            print(error)
        }
        else if let data = data {
            
            do {
                let result = try? JSONDecoder().decode([CountryData].self, from: data)
                
                guard let resultOne = result else {return}
                let modelsRecovered: [DailyRecoveredData] = resultOne.compactMap {  //  2
             guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
            index2 += 1 // Add index to our dayData model // Which is just index, case, date
               
                    return DailyRecoveredData(indexRecovered: index2-1, dateRecovered: date, casesRecovered: $0.cases)
                }
                completion(.success(modelsRecovered))
                
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    task.resume()
}
    
func getCountryTotalStatus(iso: String, scope: String, completion: @escaping (Result<[DailyTotalData], BHError>) -> Void ) {

    let baseURL = "https://api.covid19api.com/country/\(iso)/status/confirmed"
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
                let modelsTotal: [DailyTotalData] = resultOne.compactMap {
                    
            guard let date = DateFormatter.dayFormatter.date(from: $0.date) else {return nil}
                    index2 += 1
               
                    return DailyTotalData(indexTotal: index2-1, dateTotal: date, casesTotal: $0.cases)
                }
                completion(.success(modelsTotal))
                
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    task.resume()
    }
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

