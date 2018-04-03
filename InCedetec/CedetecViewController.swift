//
//  CedetecViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 03/04/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

class CedetecViewController: UIViewController {

    
    
    
    @IBAction func next(_ sender: UIButton) {
        print("Espera")
        performSegue(withIdentifier: "next", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PortalViewController{
            //destination.salon = sectionData[(tableView.indexPathForSelectedRow?.row)]
            let s = Salon(nombre: "Laboratorio de redes 1", img: "redes1", piso: "3")
            destination.salon = s
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
