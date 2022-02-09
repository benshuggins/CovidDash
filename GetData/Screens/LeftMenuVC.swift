//
//  DeveloperMenuVC.swift
//  Covid19iOSCharts
//
//  Created by Ben Huggins on 12/2/21.
//

import UIKit

class LeftTableHeaderCell: UITableViewHeaderFooterView, UITableViewDelegate {

    static let identifier = "TableHeaderDev"

    private let imageView: UIImageView = {
      let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "benImage")
      return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Api Used:"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: contentView.frame.size.height-10-label.frame.size.height, width: contentView.frame.size.width, height: contentView.frame.size.height)

        imageView.frame = CGRect(x: 0, y: 40, width: contentView.frame.size.width, height: contentView.frame.size.height-15-label.frame.size.height+180)
    }
}

class LeftMenuVC: UIViewController {
    
    var sectionTitles = ["About this Demo App", "Developer", "hey"]
        var sectionContent = [["Api Used: www.covid19api.com", "Get Code GitHub"],["Linkedin","Github","Email","Call"],["Linkedin","Github"]]
       
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(RightTableHeaderCell.self, forHeaderFooterViewReuseIdentifier: "header")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        
        //Large Titles for iOS 13/14
                // Alternatively, check Storyboard NavigationBar 'PrefersLargeTitle'
        if #available(iOS 13.0, *) {
                    navigationController?.navigationBar.prefersLargeTitles = true
                    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                } else {
                    // Fallback on earlier versions
                }
                // remove bottom blank cells in the table view
                tableView.tableFooterView = UIView(frame: CGRect.zero)
        
                //iPad Layout: adds blank space to the left and right of the table view
                tableView.cellLayoutMarginsFollowReadableWidth = true
                
                // Remove text 'Settings' from back button
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  
            }
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}
    extension LeftMenuVC: UITableViewDelegate, UITableViewDataSource {
        
         func numberOfSections(in tableView: UITableView) -> Int {
                return sectionTitles.count
            }
            
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
                switch section {
                case 0:
                    return sectionContent[0].count      // section 0 is the 1st/Top section 'Setup'
                case 1:
                    return sectionContent[1].count      // section 1 is the 2nd section 'Support'
                case 2:
                    return sectionContent[2].count      // section 2 is the 3rd section 'Socially Yours'
                default:
                    return sectionContent[0].count
                }
            }
        
            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? LeftTableHeaderCell
                return header
        }
        

            func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                    
                return sectionTitles[section]  // section 0 is the 1st section
            }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            //cell.accessoryType = .disclosureIndicator
                // Configure the cell...array of content within array of headers
                cell.textLabel?.text = sectionContent[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                
                switch (indexPath as NSIndexPath).section {
                    
                case 0:  // Section 0 Setup
                    cell.accessoryType = .disclosureIndicator
                   
                case 1: // section 1 Support
                    cell.accessoryType = .none
                    
                case 2:  // Section 0 Setup
                    cell.accessoryType = .disclosureIndicator

        default: break
                }
                        
             //   cell.imageView?.image = UIImage(named: imageFileName)
                return cell
            }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        switch (indexPath as NSIndexPath).section {
                    
        case 0: // Section 0 Setup
            switch (indexPath as NSIndexPath).row {
            case 0:
                print("open an alertView")
              showSimpleActionSheet()
              // performSegue(withIdentifier: "showCloud", sender: self)
            case 1:
               // print("")
              showSimpleAlert()
            default:
            print(#function, "Error in Switch")
            } // end case section 0 switch
                    
        case 1: // section 1 Support
        switch (indexPath as NSIndexPath).row {
        case 0:
            print("1")
            if let url = URL(string: "https://www.covid19api.com") {
                UIApplication.shared.open(url)
            }
        case 1:
            print("1")
             // performSegue(withIdentifier: "showCredits", sender: self)
        case 2:
            print("1")
             // performSegue(withIdentifier: "showPrivacy", sender: self)
        case 3:
            print("1")
             // performSegue(withIdentifier: "showBlog", sender: self)
        default:
            print("1")
             // performSegue(withIdentifier: "showAppInfo", sender: self)
        }
            
        case 2: // Section 0 Setup
            switch (indexPath as NSIndexPath).row {
            case 0:
               performSegue(withIdentifier: "showCloud", sender: self)
            case 1:
               performSegue(withIdentifier: "showDataIntegrityReset", sender: self)
            default:
            print(#function, "Error in Switch")
            } // end
                    
        default: break
        } // end case section 1switch
                
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func showSimpleAlert() {
            let alert = UIAlertController(title: "The Point", message: "This Demo app compares how Covid19 has affected Countries of the World on 3 metrics: Total Cases, Total Recovered Cases, Total Deaths per day all Graphically", preferredStyle: .alert)
  
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { _ in
                   //Cancel Action
               }))
               self.present(alert, animated: true, completion: nil)
           }
        
        func showSimpleActionSheet() {
              let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
              alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
                  print("User click Dismiss button")
              }))

              self.present(alert, animated: true, completion: {
                  print("completion block")
              })
          }
        
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showCloud":
            print("1")
       // _ = segue.destination as! CloudTableViewController
        case "showDataIntegrityReset":
      //  _ = segue.destination as! ResetDataIntegrityViewController
            print("1")
        case "showAppInfo":
      //  let appInfoViewController = segue.destination as! AppInfoViewController
      //  appInfoViewController.title = "AppsGym Books Info"
            print("1")
        case "showCredits":
      //  _ = segue.destination as! CreditsViewController
            print("1")
        case "showPrivacy":
            print("1")
      //  _ = segue.destination as! PrivacyViewController
        case "showBlog":
            print("1")
      //  _ = segue.destination as! BlogViewController
        default:
            print("default")
       // _ = segue.destination as! SettingsTableViewController
        }
           
           
         
               
        } // end class
}


