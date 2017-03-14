//
//  AMContactsViewController.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 13/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit
import PKHUD

class AMContactsViewController: UITableViewController {

    var allContacts: [AMContact] = []
    var filteredContacts: [AMContact] = []
    
    var searchBar = UISearchBar()
    var isFetchingData = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Task 1"
        
        searchBar.placeholder = "Search"
        searchBar.barTintColor = AMColor.appBlue
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.tintColor = AMColor.appDarkBlack
        
        self.tableView.register(AMContactsCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.register(AMAudioContactsCell.self, forCellReuseIdentifier: "audioReuseIdentifier")
        self.tableView.register(AMEmptyCell.self, forCellReuseIdentifier: "emptyCell")
        self.tableView.separatorColor = UIColor.clear
        self.tableView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = AMColor.appLightGray
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let contactManager: AMContactManager = AMContactManager()
        contactManager.getAllContacts { (contacts) in
            self.allContacts.append(contentsOf: contacts)
            self.filteredContacts = self.allContacts
            PKHUD.sharedHUD.hide()
            self.isFetchingData = false
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Helper
    
    func searchFor(name: String) {
        
        let queue: DispatchQueue = DispatchQueue.global(qos: .background)
        queue.async {
            let contacts = self.allContacts.filter{ $0.givenName.contains(name) }
            DispatchQueue.main.async {
                self.filteredContacts = contacts
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - UITableViewDataSource

extension AMContactsViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return filteredContacts.count > 0 ? 90 : (self.tableView.bounds.size.height-50)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredContacts.count > 0 ? filteredContacts.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if filteredContacts.count > 0 {
            guard let cell:AMContactsCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? AMContactsCell else {
                return UITableViewCell()
            }
            
            var contact: AMContact = AMContact(primaryPhoneNumber: "", givenName: "", thumbImage: nil)
            
            if indexPath.row < self.filteredContacts.count {
                contact = filteredContacts[indexPath.row]
            }
            
            cell.nameLabel.text = contact.givenName
            cell.phoneNumberLabel.text = contact.primaryPhoneNumber
            if let image:UIImage = contact.thumbImage {
                cell.thumbImageView.image = image
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        
        guard let cell:AMEmptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? AMEmptyCell else {
            return UITableViewCell()
        }
            
        cell.messageLabel.text = self.isFetchingData ? "" : "No results found for search"
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        return cell
    }
}

//MARK: - UITableViewDelegate

extension AMContactsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return self.searchBar;
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50;
    }
}

//MARK: - UISearchBarDelegate

extension AMContactsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var searched: Bool = false
        if let searchText = searchBar.text {
            if searchText.characters.count > 0 {
                self.searchFor(name: searchText)
                searched = true
            }
        }
        if !searched {
            self.filteredContacts = self.allContacts
            self.tableView.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        self.filteredContacts = self.allContacts
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

