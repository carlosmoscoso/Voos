//
//  AirportWatchlistController.swift
//  Voos
//
//  Created by Carlos Alexandre Moscoso on 06/10/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol AirportWatchlistControllerDelegate: class {
    func airportWatchlistControllerInfraeroButtonTapped(_ controller: AirportWatchlistController)
    func airportWatchlistControllerWasFinished(_ controller: AirportWatchlistController)
}

class AirportWatchlistController: UITableViewController {

    var airports = [Airport]()
    
    weak var delegate: AirportWatchlistControllerDelegate?
    
    @IBAction func open(_ sender: UIBarButtonItem) {
        delegate?.airportWatchlistControllerInfraeroButtonTapped(self)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        delegate?.airportWatchlistControllerWasFinished(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        navigationItem.title = "Aeroportos"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isEditing = true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let searchController = navigationController.viewControllers.first as? SearchAirportController {
            
            searchController.watchedAirports = airports
            searchController.delegate = self
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = airports[indexPath.row].code.uppercased()
        cell.detailTextLabel?.text = airports[indexPath.row].displayName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt from: IndexPath, to: IndexPath) {
        airports.insert(airports.remove(at: from.row), at: to.row)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        airports.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension AirportWatchlistController: SearchAirportControllerDelegate {
    func searchAirportController(_ controller: SearchAirportController, didFindAirport airport: Airport) {
        airports.append(airport)
        
        tableView.reloadData()
    }
    
    func searchAirportControllerWasCanceled(_ controller: SearchAirportController) {
        dismiss(animated: true)
    }
}
