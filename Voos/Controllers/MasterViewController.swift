//
//  MasterViewController.swift
//  Voos
//
//  Created by Carlos Alexandre Moscoso on 03/10/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MasterViewController: UITableViewController {

    var displayedAirports: [Airport] {
        get {
            let data = UserDefaults.standard.value(forKey: "watching") as! Data
            
            return try! PropertyListDecoder().decode([Airport].self, from: data)
        }
        set {
            let data = try! PropertyListEncoder().encode(newValue)
            
            UserDefaults.standard.set(data, forKey: "watching")
        }
    }
    
    @IBAction func open() {
        UIApplication.shared.open(
            URL(string: "https://www.infraero.gov.br/")!
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let defaultAirports = try! PropertyListDecoder()
            .decode([Airport].self, from: NSDataAsset(name: "Airports")!.data)
            .filter({ ["sdu", "gru", "gig", "cgh"].contains($0.code) })
            .sorted(by: { $0.displayName < $1.displayName })

        let data = try! PropertyListEncoder().encode(defaultAirports)
        
        UserDefaults.standard.register(defaults: ["watching":data])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.preferredDisplayMode = .allVisible
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        clearsSelectionOnViewWillAppear = true//splitViewController!.isCollapsed
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(Airport.load())
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let watchlistController = navigationController.viewControllers.first as? AirportWatchlistController {
            
            watchlistController.airports = displayedAirports
            watchlistController.delegate = self
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedAirports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel!.text = displayedAirports[indexPath.row].code.uppercased()
        cell.detailTextLabel!.text = displayedAirports[indexPath.row].displayName
        
        return cell
    }
}

extension MasterViewController: AirportWatchlistControllerDelegate {
    func airportWatchlistControllerInfraeroButtonTapped(_ controller: AirportWatchlistController) {
        open()
    }
    
    func airportWatchlistControllerWasFinished(_ controller: AirportWatchlistController) {
        displayedAirports = controller.airports
        
        tableView.reloadData()
        
        dismiss(animated: true)
    }
}
