//
//  SalonesViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 27/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit


/*struct Salon: Decodable{
    let nombre : String
    let img : String
    let piso : String
}*/


class SalonesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    //Loading data

    
    var salones = [Salon]()
    
    var primerpiso : Int = 0
    var segundopiso : Int = 0
    var tercerpiso : Int = 0
    var cuartopiso : Int = 0
    
    var salonesprimer : [Salon] = []
    var salonessegundo : [Salon] = []
    var salonestercer : [Salon] = []
    var salonescuarto : [Salon] = []
    
    let sections : [String] = ["Primer piso","Segundo piso", "Tercer piso", "Cuarto piso"]
    
    var sectionData : [Int:[Salon]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController()
    var resultController = UITableViewController()
    var totalResults = [String]()
    var filteredArray = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: resultController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        resultController.tableView.delegate = self
        resultController.tableView.dataSource = self
        
        
        let url = URL(string: "http://199.233.252.86/201811/incedetec/salones.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.salones = try JSONDecoder().decode([Salon].self, from: data!)
                }catch{
                    print("Parse error")
                }
                DispatchQueue.main.async {
                    print(self.salones.count)
                    self.tableView.reloadData()
                    self.loadData()
                    
                }
                
            }
            
        }.resume()
        
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = totalResults.filter({ (totalResults:String) -> Bool in
            if totalResults.contains(searchController.searchBar.text!){
                return true
            }else{
                return false
            }
            
        })
        
        resultController.tableView.reloadData()
    }
    
    func loadData(){
        for  salon in self.salones {
            if(salon.piso == "1"){
                self.primerpiso += 1;
                self.salonesprimer.append(salon)
                self.totalResults.append(salon.nombre)
            }else if(salon.piso == "2"){
                self.segundopiso += 1;
                self.salonessegundo.append(salon)
                self.totalResults.append(salon.nombre)
            }else if(salon.piso == "3"){
                self.tercerpiso += 1;
                self.salonestercer.append(salon)
                self.totalResults.append(salon.nombre)
            }else if(salon.piso == "4"){
                self.cuartopiso += 1;
                self.salonescuarto.append(salon)
                self.totalResults.append(salon.nombre)
            }
        }
        
        print("Primer piso hay "+String(self.primerpiso))
        print("Segundo piso hay "+String(self.segundopiso))
        print("Tercer piso hay "+String(self.tercerpiso))
        print("Cuarto piso hay "+String(self.cuartopiso))
        
        self.sectionData = [0 : self.salonesprimer, 1 : self.salonessegundo, 2 : self.salonestercer, 3 : self.salonescuarto]
        print(sectionData)
        
    }
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return salones.count
        //print(self.salonesprimer)
        if tableView == resultController.tableView{
            return filteredArray.count
            //return self.sectionData[filteredArray.count]!.count
        }else{
            let s = Salon(nombre: "", img: "", piso: "")
            
            sectionData = [0 : [s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s], 1: [s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s], 2 : [s,s,s,s,s,s,s,s,s,s,s,s,s,s], 3 : [s,s,s,s,s,s,s,s]]
            
            //print(sectionData)
            return(self.sectionData[section]!.count)
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == resultController.tableView{
            return "Resultados Busqueda"
        }else{
            return sections[section]
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == resultController.tableView{
            return 1
        }else{
            return sections.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if tableView == resultController.tableView{
           cell.textLabel?.text = filteredArray[indexPath.row]
        
        }else{
            cell.textLabel?.text = sectionData[indexPath.section]![indexPath.row].nombre.capitalized
            //cell.textLabel?.text = salones[indexPath.row].nombre.capitalized
            //var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        }
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destination = segue.destination as? PortalViewController{
            //destination.salon = sectionData[(tableView.indexPathForSelectedRow?.row)]
            
            destination.salon = salones[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    

}
