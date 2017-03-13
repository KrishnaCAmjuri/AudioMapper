//
//  AMContactsViewController.swift
//  AudioMapper
//
//  Created by KrishnaChaitanya Amjuri on 13/03/17.
//  Copyright © 2017 Krishna Chaitanya. All rights reserved.
//

import UIKit

class AMContactsViewController: UITableViewController {

    var allContacts: [AMContact] = []
    var filteredContacts: [AMContact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(AMContactsCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let contactManager: AMContactManager = AMContactManager()
        contactManager.getAllContacts { (contacts) in
            self.allContacts.append(contentsOf: contacts)
            self.filteredContacts = self.allContacts
            self.tableView.reloadData()
            self.searchFor(name: "Raj")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredContacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let contact: AMContact = filteredContacts[indexPath.row]
        
        guard let cell:AMContactsCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? AMContactsCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = contact.givenName
        cell.phoneNumberLabel.text = contact.primaryPhoneNumber
        if let image:UIImage = contact.thumbImage {
            cell.thumbImageView.image = image
        }
        
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Helper
    
    func searchFor(name: String) {
        
        let queue: DispatchQueue = DispatchQueue.global(qos: .background)
        queue.async {
            self.filteredContacts = self.allContacts.filter{ $0.givenName.contains(name) }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}
