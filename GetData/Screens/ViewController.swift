//
//  ViewController.swift
//  GetData
//
//  Created by Ben Huggins on 7/12/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    let menuVC = MenuVC()
    
    // removing/ filtering certain object data
    
    var countries: [Country] = [] {
        didSet {
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
   
    
    var searchedCountries: [Country] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var isSearching = false
    
    let searchBar = UISearchBar()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CountriesNameTableViewCell.self, forCellReuseIdentifier: CountriesNameTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "COVID19"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.addSubview(searchBar)
        getCountryName()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Enter Country"
        navigationItem.searchController = search
        
        
        let rightBarButtonItem = UIBarButtonItem(title: "Menu", style: .done, target: self, action: #selector(rightBarButtonTapped))
        
        self.navigationItem.rightBarButtonItem  = rightBarButtonItem
        
    }
    
    @objc func rightBarButtonTapped() {
        
        print("RIGHT BAR BUTTON WAS TAPPED")
        navigationController?.pushViewController(menuVC, animated: true)
        //self.present(menuVC, animated: true, completion: nil)
        
    }

    func getCountryName() {
        //createSpinnerView()
        APICaller.shared.getCountryNames { [weak self] result in
            switch result {
            case .success(let countries):
                
                
                
               
                self?.countries = countries
               // print("🍟🍟🍟🍟🍟\(countries)")

            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedCountries.count
        } else {
            return countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountriesNameTableViewCell.identifier, for: indexPath) as! CountriesNameTableViewCell
        
        if isSearching {
            
            cell.itemLandingPad = searchedCountries[indexPath.row]
        } else {
            cell.itemLandingPad = countries[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching{
            
            let selectedRow = searchedCountries[indexPath.row]
            print("Row Number: \(selectedRow)")
            let name = selectedRow.name
            let iso = selectedRow.iso
            
            let secondVC = CountryDetailViewController(countryName: name, isoItem: iso)
            present(UINavigationController(rootViewController: secondVC), animated: true)
            createSpinnerView()
            
        } else {
           
            let selectedRow = countries[indexPath.row]
            print("Row Number: \(selectedRow)")
            let name = selectedRow.name
            let iso = selectedRow.iso
            
            let secondVC = CountryDetailViewController(countryName: name, isoItem: iso)
            present(UINavigationController(rootViewController: secondVC), animated: true)
            createSpinnerView()
        }
    }
}

extension ViewController {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
                print(text)
        
        searchedCountries = countries.filter{ $0.name.lowercased().prefix(text.count) == text.lowercased()
        }
        print("🥩🥩🥩🥩🥩🥩\(searchedCountries)")
        isSearching = true
        tableView.reloadData()
    }
}
