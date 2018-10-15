//
//  SearchAirportController.swift
//  Voos
//
//  Created by Carlos Alexandre Moscoso on 06/10/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol SearchAirportControllerDelegate: class {
    func searchAirportController(_ controller: SearchAirportController, didFindAirport airport: Airport)
    func searchAirportControllerWasCanceled(_ controller: SearchAirportController)
}

class SearchAirportController: UITableViewController {

    private let availableAirports = try! PropertyListDecoder()
        .decode([Airport].self, from: NSDataAsset(name: "Airports")!.data)
        .sorted(by: { $0.displayName < $1.displayName })
    
    private var results = [String:[Airport]]()
    
    var watchedAirports = [Airport]()
    
    weak var delegate: SearchAirportControllerDelegate?
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        delegate?.searchAirportControllerWasCanceled(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Scroll view delegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results[["Seguindo", "Aeroportos"][section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return results[["Seguindo", "Aeroportos"][section]]!.isEmpty ? nil : ["Seguindo", "Aeroportos"][section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = results["Seguindo"]![indexPath.row].code.uppercased()
            cell.detailTextLabel?.text = results["Seguindo"]![indexPath.row].displayName
        default:
            cell.textLabel?.text = results["Aeroportos"]![indexPath.row].code.uppercased()
            cell.detailTextLabel?.text = results["Aeroportos"]![indexPath.row].displayName
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .insert
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let airport = results["Aeroportos"]!.remove(at: indexPath.row)
        
        let index = results["Seguindo"]!.count
        
        results["Seguindo"]!.append(airport)
        
        tableView.performBatchUpdates({
            
            tableView.deleteRows(at: [indexPath], with: indexPath.row > 0 ? .middle : .fade)
            
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: index == 0 ? .left : .fade)
            
        }, completion: { _ in
            
            self.watchedAirports.append(airport)
            
            self.delegate?.searchAirportController(self, didFindAirport: airport)
        })
    }
}

extension SearchAirportController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            results.removeAll()
            
        } else {
            
            let lowercaseText = searchText.lowercased()
            
            results = [
                "Seguindo" : watchedAirports.filter({ a in
                    a.code.lowercased().hasPrefix(lowercaseText) ||
                    a.name.folding(options: .diacriticInsensitive, locale: .current).lowercased().hasPrefix(lowercaseText) ||
                    a.displayName.folding(options: .diacriticInsensitive, locale: .current).lowercased().hasPrefix(lowercaseText)
                }),
                
                "Aeroportos" : availableAirports.filter({ a in
                    (a.code.lowercased().hasPrefix(lowercaseText) ||
                    a.name.folding(options: .diacriticInsensitive, locale: .current).lowercased().hasPrefix(lowercaseText) ||
                    a.displayName.folding(options: .diacriticInsensitive, locale: .current).lowercased().hasPrefix(lowercaseText)) &&
                    !watchedAirports.contains(where: { $0.code == a.code })
                })
            ]
        }
        
        tableView.reloadData()
    }
}
