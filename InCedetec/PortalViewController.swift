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

class PortalViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, ARSCNViewDelegate{
    
     let itemsArray: [String] = ["microfono", "USB", "desarmador", "LlaveMecanica"]

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var planeDetected: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var buttonMostrar: UIButton!
    //  droneNode
    
    
    @IBOutlet weak var TextoInformativo: UILabel!
    @IBAction func MostrarInformacionMaterial(_ sender: UIButton) {
        TextoInformativo.isHidden = false
    }
    @IBOutlet weak var buttonMostrarInfo: UIButton!
    @IBAction func Add3dImage(_ sender: Any) {
        self.addNode()
        buttonMostrar.isHidden = true
        buttonMostrarInfo
            .isHidden = false
    }
    
    var droneNode = SCNNode()
    
    func addNode(){
        let droneScene = SCNScene(named: "art.scnassets/model.scn")
        droneNode = (droneScene?.rootNode.childNode(withName: "Drone",recursively: false ))!
        droneNode.position = SCNVector3(0,0,-1 )
        self.sceneView.scene.rootNode.addChildNode(droneNode)
    }
    
    
    
    let configuration = ARWorldTrackingConfiguration()
    
    var selectedItem: String? //Material de salón

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
        
        //itemsCollectionView
        self.itemsCollectionView.dataSource = self
        self.itemsCollectionView.delegate = self
        
        self.sceneView.delegate = self
        
        self.registerGestureRecognizers()
        self.sceneView.autoenablesDefaultLighting = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(escalado))
        
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        
        droneNode.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
    }
    
    @IBAction func mostrarDescripcion2(_ sender: UITapGestureRecognizer) {
        let escena = sender.view as! SCNView
        let location = sender.location(in: escena)
        let hitResults  = escena.hitTest(location, options: [:])
        if !hitResults.isEmpty{
            let nodoTocado = hitResults[0].node
            nodoTocado.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            
            //material.diffuse.contents = UIColor.grayColor()
            
        }
        
        
    }

    
    @objc func handleTap(sender : UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else{return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        //.existingPlaneUsingExtent
        //let hitTestResult = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResult.isEmpty{
           // if(hitTestResult[0].node == droneNode){
                
             //   droneNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            //}else{
                self.addPortal(hitTestResult: hitTestResult.first!)
            //}
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
    
    @IBAction func rotar(_ sender: UIRotationGestureRecognizer) {
        droneNode.eulerAngles = SCNVector3(0,sender.rotation,0)
    }
    
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
        let texto = "Estoy probando el drone en el salón :" + (salon?.nombre)!
        
        let objetos:[AnyObject]=[texto as AnyObject]
        let actividad = UIActivityViewController(activityItems: objetos,applicationActivities: nil)
        // actividad.excludedActivityTypes=[UIActivityType.airDrop]
        self.present(actividad,animated: true,completion: nil)
    }
    
    var pantallaPlanaNodo = SCNNode()
     var videoNodo = SKVideoNode()
    
    @IBOutlet weak var MostrarVideoObj: UIButton!
    @IBAction func ButtonMostrarVideo(_ sender: UIButton) {
        guard let currentFrame = self.sceneView.session.currentFrame else {return}
        
        
        let moviePath = "http://ebookfrenzy.com/ios_book/movie/movie.mov"
        let url = URL(string: moviePath)
        let player = AVPlayer(url: url!)
        player.volume = 0.5
        print(player.isMuted)
        
        // crear un nodo capaz de reporducir un video
        //let videoNodo = SKVideoNode(url: url!)
        videoNodo = SKVideoNode(fileNamed: "TutorialDrone.mov")
        videoNodo.play() //ejecutar play al momento de presentarse
       
        
        //crear una escena sprite kit, los parametros estan en pixeles
        let spriteKitEscene =  SKScene(size: CGSize(width: 640, height: 480))
        spriteKitEscene.addChild(videoNodo)
        
        //colocar el videoNodo en el centro de la escena tipo SpriteKit
        videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
        videoNodo.size = spriteKitEscene.size
        
        //crear una pantalla 4/3, los parametros son metros
        let pantalla = SCNPlane(width: 1.0, height: 0.75)
        
        //modificar el material del plano
        pantalla.firstMaterial?.diffuse.contents = spriteKitEscene
        //permitir ver el video por ambos lados
        pantalla.firstMaterial?.isDoubleSided = true
        
         pantallaPlanaNodo = SCNNode(geometry: pantalla)
        //identificar en donde se ha tocado el currentFrame
        var traduccion = matrix_identity_float4x4
        //definir un metro alejado del dispositivo
        traduccion.columns.3.z = -1.0
        pantallaPlanaNodo.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
        
        pantallaPlanaNodo.eulerAngles = SCNVector3(Double.pi, 0, 0)
        self.sceneView.scene.rootNode.addChildNode(pantallaPlanaNodo)
        
        MostrarVideoObj.isHidden = true
        PauseBut.isHidden = false
        QuitBut.isHidden = false
    }
    
    @IBOutlet weak var PauseBut: UIButton!
    @IBOutlet weak var PlayBut: UIButton!
    @IBOutlet weak var QuitBut: UIButton!
    
    @IBAction func QuitVideoButton(_ sender: UIButton) {
        pantallaPlanaNodo.isHidden = true
        videoNodo.pause()
        MostrarVideoObj.isHidden = false
        QuitBut.isHidden = true
        PlayBut.isHidden = true
        PauseBut.isHidden = true
    }
    
    @IBAction func PlayVideoButton(_ sender: UIButton) {
        PlayBut.isHidden = true
        PauseBut.isHidden = false
        videoNodo.play()
    }
    
    @IBAction func PauseVideoButton(_ sender: UIButton) {
        PlayBut.isHidden = false
        PauseBut.isHidden = true
        videoNodo.pause()
    }
    
    
    //Empieza mostrar Materiales
    func registerGestureRecognizers() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
        
        
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    func addItem(hitTestResult: ARHitTestResult) {
        
        
        if let selectedItem = self.selectedItem {
            let scene = SCNScene(named: "art.scnassets/\(selectedItem).scn")
            let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCell
        cell.itemLabel.text = self.itemsArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.selectedItem = itemsArray[indexPath.row]
        cell?.backgroundColor = UIColor.green
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red: 0.0902, green: 0.1098, blue: 0.2275, alpha: 1)
    }
    
   
    
}


extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

