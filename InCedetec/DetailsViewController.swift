//
//  DetailsViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 29/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit



class DetailsViewController: UIViewController {

    @IBOutlet weak var link: UILabel!
    
    var salon:Salon?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        link.text = salon?.img
    }


}
