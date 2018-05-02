//
//  PisosViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 02/05/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

class PisosViewController: UITableViewController{
    
    private let datos = ["Primer piso","Segundo piso","Tercer piso","Cuarto piso"]
    let identificador = "Identificador"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Identificador", for: indexPath)
        if (cell == nil){
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identificador)
        }
        cell.textLabel?.text = datos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "nextSalones", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sigVista = segue.destination as! SalonesViewController
        let indice = self.tableView.indexPathForSelectedRow?.row
        sigVista.piso = datos[indice!]
    }
    

}
