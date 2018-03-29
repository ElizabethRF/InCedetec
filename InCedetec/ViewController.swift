//
//  ViewController.swift
//  InCedetec
//
//  Created by Elizabeth Rodríguez Fallas on 18/02/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.navigationBar.topItem!.title = "Menú principal"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SalonesButton(_ sender: UIButton) {
    }
    @IBAction func CEDETECButton(_ sender: UIButton) {
    }
    @IBAction func ProyectosButton(_ sender: UIButton) {
    }
    @IBAction func About(_ sender: UIButton) {
    }
    
    @IBAction func fbButton(_ sender: UIButton) {
        let texto = "Estoy usando InCedetec"
        let objetos:[AnyObject]=[texto as AnyObject]
        let actividad = UIActivityViewController(activityItems: objetos,applicationActivities: nil)
       // actividad.excludedActivityTypes=[UIActivityType.airDrop]
        self.present(actividad,animated: true,completion: nil)
    }
    @IBAction func ttButton(_ sender: UIButton) {
    }
    
    @IBAction func IGButton(_ sender: UIButton) {
    }
    
    
    
}

