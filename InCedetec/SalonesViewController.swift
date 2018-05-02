//
//  SalonesViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 27/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
// Hola carlos 

import UIKit


/*struct Salon: Decodable{
    let nombre : String
    let img : String
    let piso : String
}*/


class SalonesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    //Loading data
    var piso :String = "" 
    
    var salones = [Salon]()
    
    var primerpiso : Int = 0
    var segundopiso : Int = 0
    var tercerpiso : Int = 0
    var cuartopiso : Int = 0
    
    var salonesprimer : [Salon] = []
    var salonessegundo : [Salon] = []
    var salonestercer : [Salon] = []
    var salonescuarto : [Salon] = []
    var salonesFinales : [Salon] = []
    
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
        
        
        
        downloadJSON {
            print("si se pudo perro")
            
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
            
            if(self.piso == "Primer piso"){
                print("Primer piso")
                self.salonesFinales = self.salonesprimer
                print(self.salonesFinales)
            }else if(self.piso == "Segundo piso"){
                print("Segundo piso")
                self.salonesFinales = self.salonessegundo
                print(self.salonesFinales)
            }else if(self.piso == "Tercer piso"){
                print("Tercer piso")
                self.salonesFinales = self.salonestercer
                print(self.salonesFinales)
            }else if(self.piso == "Cuarto piso"){
                print("Cuarto piso")
                self.salonesFinales = self.salonescuarto
                print(self.salonesFinales)
            }
            
            self.tableView.reloadData()
        }
   
        
        
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string:"http://199.233.252.86/201811/incedetec/salones.json")
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if error == nil{
                do{
                    self.salones = try JSONDecoder().decode([Salon].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                        //self.loadData()
                    }
                }catch{
                    print("JSON ERROR")
                }
            }
            
        }.resume()
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
        //print(sectionData)
        
        if(piso == "Primer piso"){
            print("Primer piso")
            self.salonesFinales = salonesprimer
            print(salonesFinales)
        }else if(piso == "Segundo piso"){
            print("Segundo piso")
            self.salonesFinales = salonessegundo
            print(salonesFinales)
        }else if(piso == "Tercer piso"){
            print("Tercer piso")
            self.salonesFinales = salonestercer
            print(salonesFinales)
        }else if(piso == "Cuarto piso"){
            print("Cuarto piso")
            self.salonesFinales = salonescuarto
            print(salonesFinales)
        }
        
    }
    
    /*func updateSearchResults(for searchController: UISearchController) {
        filteredArray = totalResults.filter({ (totalResults:String) -> Bool in
            if totalResults.contains(searchController.searchBar.text!){
                return true
            }else{
                return false
            }
            
        })
        
        resultController.tableView.reloadData()
    }*/
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        
        return self.salonesFinales.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = self.salonesFinales[indexPath.row].nombre.capitalized
        
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if((salones[(tableView.indexPathForSelectedRow?.row)!].img == "cabinacontrol") || (salones[(tableView.indexPathForSelectedRow?.row)!].img == "estudiodetv")
            ){
            if let destination = segue.destination as? PortalViewController{
                //destination.salon = sectionData[(tableView.indexPathForSelectedRow?.row)]
                
                destination.salon = salones[(tableView.indexPathForSelectedRow?.row)!]
            }
        }else{
            let alert = UIAlertController(title: "Lo sentimos, salon en construcción", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
    
      
    }
    
    

}
