//
//  PortalViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 29/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit
import ARKit

class PortalViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var planeDetected: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "arriba")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "abajo")
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "centro")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "izquierda")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "derecha")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "izquierda")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "derecha")
        
        
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
    
    func addWalls(nodeName : String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scncassets/\(imageName).png")
    }
    
    func addPlane(nodeName : String, portalNode: SCNNode, imageName: String){
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scncassets/\(imageName).png")
    }

}
