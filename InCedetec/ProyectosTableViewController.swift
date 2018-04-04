//
//  ProyectosTableViewController.swift
//  InCedetec
//
//  Created by Elizabeth Rodríguez Fallas on 19/02/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit
import CoreData

class ProyectosTableViewController: UITableViewController{
    
    var projects : [NSManagedObject] = [];
    let cellId = "cellId";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addProject))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellId);
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Project")
        
        do {
            projects = try managedContext.fetch(fetchRequest)
        }catch let err as NSError {
            print("fallo el fetch", err)
        }
    }
    
    @objc func addProject(_ sender: Any) {
        let alertController = UIAlertController(title: "Agregar nuevo proyecto", message: "Nombre del proyecto", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Agregar", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let projectToAdd = textField.text else{ return}
            self.save(projectToAdd)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController,animated: true,completion: nil)
        
    }
    
    func save(_ projectName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Project", in: managedContext)!
        let project = NSManagedObject(entity: entity, insertInto: managedContext)
        project.setValue(projectName, forKey: "projectName")
        
        do {
            try managedContext.save()
            projects.append(project)
        }catch let err as NSError {
            print("Fallo al guardar proyecto", err)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.text = project.value(forKey: "projectName") as? String
        return cell
    }
}
