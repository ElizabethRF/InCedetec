//
//  SalonesViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 27/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

struct Salon: Decodable{
    let nombre: String
}


class SalonesViewController: UIViewController, UICollectionViewDataSource {

    
    
    var salones = [Salon]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let url = URL(string: "http://199.233.252.86/201811/incedetec/salones.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.salones = try JSONDecoder().decode([Salon].self, from: data!)
                }catch{
                    print("Parse error")
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }.resume()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return salones.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.namelbl.text = salones[indexPath.row].nombre.capitalized //nombre o url a imagen
        return cell
        
    }
    


}
