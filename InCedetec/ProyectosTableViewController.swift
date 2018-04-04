//
//  ProyectosTableViewController.swift
//  InCedetec
//
//  Created by Elizabeth Rodríguez Fallas on 19/02/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

class ProyectosTableViewController: UITableViewController{
    
    var projects : [String] = [];
    let cellId = "cellId";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addProject))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellId);
      
    }

    @objc func addProject(_ sender: Any) {
        let alertController = UIAlertController(title: "Agregar nuevo proyecto", message: "Nombre del proyecto", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Agregar", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let projectToAdd = textField.text else{ return}
            self.projects.append(projectToAdd)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.text = project
        return cell
    }
}
