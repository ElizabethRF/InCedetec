//
//  PortalViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 29/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit
import ARKit


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class PortalViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var planeDetected: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    @IBAction func Add3dImage(_ sender: Any) {
        self.addNode()
    }
    
    func addNode(){
        let droneScene = SCNScene(named: "art.scnassets/model.scn")
        let droneNode = droneScene?.rootNode.childNode(withName: "Drone",recursively: false )
        droneNode?.position = SCNVector3(0,0,-1 )
        self.sceneView.scene.rootNode.addChildNode(droneNode!)
    }
    
    
    
    let configuration = ARWorldTrackingConfiguration()
   
    
    var dataabajo : Data?
    var dataarriba : Data?
    var datacentro : Data?
    var dataDerecha : Data?
    var dataFrente : Data?
    var dataIzquierda : Data?
    
    var salon:Salon?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //PARA JALAR LA IMAGEN DEL JSON
        let urlStringabajo = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/abajo.png"
        print(urlStringabajo)
        let urlabajo = URL(string: urlStringabajo)
        dataabajo = try? Data(contentsOf: urlabajo!)
        
        let urlStringarriba = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/arriba.png"
        let urlarriba = URL(string: urlStringarriba)
        dataarriba = try? Data(contentsOf: urlarriba!)
        
        let urlStringcentro = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/centro.png"
        let urlcentro = URL(string: urlStringcentro)
        datacentro = try? Data(contentsOf: urlcentro!)
        
        let urlStringderecha = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/derecha.png"
        let urlderecha = URL(string: urlStringderecha)
        dataDerecha = try? Data(contentsOf: urlderecha!)
        
        let urlStringfrente = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/frente.png"
        let urlfrente = URL(string: urlStringfrente)
        dataFrente = try? Data(contentsOf: urlfrente!)
        
        
        let urlStringizquierda = "http://199.233.252.86/201811/incedetec/fotos/"+(salon?.img)!+"/izquierda.png"
        let urlizquierda = URL(string: urlStringizquierda)
        dataIzquierda = try? Data(contentsOf: urlizquierda!)
        
        
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleTap(sender : UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else{return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty{
            self.addPortal(hitTestResult: hitTestResult.first!)
        }else{
            
        }
    }
    
    func addPortal(hitTestResult:ARHitTestResult){
        let portalScene = SCNScene(named: "Portal.scncassets/Portal.scn")
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode.position = SCNVector3(planeXposition,planeYposition,planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        self.addPlane(nodeName: "roof", portalNode: portalNode, data: dataarriba!)
        self.addPlane(nodeName: "floor", portalNode: portalNode, data: dataabajo!)
        self.addWalls(nodeName: "backWall", portalNode: portalNode, data: datacentro!)
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, data: dataIzquierda!)
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, data: dataDerecha!)
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, data: dataFrente!)
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, data: dataFrente!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.planeDetected.isHidden = true
        }
    }
    
    /*func addWalls(nodeName : String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scncassets/\(imageName).png")
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false){
            mask.geometry?.firstMaterial?.transparency = 0.000001
        }
    }
    
    func addPlane(nodeName : String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scncassets/\(imageName).png")
        child?.renderingOrder = 200 
    }*/
    
    func addWalls(nodeName : String, portalNode: SCNNode, data: Data){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(data: data)
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false){
            mask.geometry?.firstMaterial?.transparency = 0.000001
        }
    }
    
    func addPlane(nodeName : String, portalNode: SCNNode, data: Data){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(data: data)
        child?.renderingOrder = 200
    }
    @IBAction func RedesSociales(_ sender: Any) {
        let texto = "Estoy probando el drone en el salón :"  + (salon?.nombre)!
        
        let objetos:[AnyObject]=[texto as AnyObject]
        let actividad = UIActivityViewController(activityItems: objetos,applicationActivities: nil)
        // actividad.excludedActivityTypes=[UIActivityType.airDrop]
        self.present(actividad,animated: true,completion: nil)
    }
    
}
