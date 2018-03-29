//
//  SalonesViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 27/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit


struct Salon: Decodable{
    let nombre : String
    let img : String
}


class SalonesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var salones = [Salon]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
                }
            }
            
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = salones[indexPath.row].nombre.capitalized
        return cell
    }
    
    

}
