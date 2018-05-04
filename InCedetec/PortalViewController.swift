//
//  PortalViewController.swift
//  InCedetec
//
//  Created by Brandon Reyes on 29/03/18.
//  Copyright © 2018 Elizabeth Rodríguez Fallas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision


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

class PortalViewController: UIViewController , UICollectionViewDelegate, ARSCNViewDelegate{
    
    private var bandera : Bool = false
    
    @IBOutlet weak var planeDetected: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var buttonMostrar: UIButton!
    //  droneNode
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
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
    
    
    var selectedItem: String? //Material de salón

    var dataabajo : Data?
    var dataarriba : Data?
    var datacentro : Data?
    var dataDerecha : Data?
    var dataFrente : Data?
    var dataIzquierda : Data?
    
    var salon:Salon?
    
    
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var usb: UIButton!
    @IBOutlet weak var desarmador: UIButton!
    
    @IBOutlet weak var llave: UIButton!
    @IBOutlet weak var microfono: UIButton!
    var banderaObjetos : Bool = false
    
    var usbButtonCenter : CGPoint!
    var desarmadorButtonCenter : CGPoint!
    var llaveButtonCenter : CGPoint!
    var microfonoButtonCenter : CGPoint!
    
    
    //MACHINE LEARNINIG
    private var hitTestResult: ARHitTestResult!
    private var resnetModel = Resnet50()
    private var visionRequests = [VNRequest]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PARA OCULTAR BOTONES DE OBJETOS
        
        usbButtonCenter = usb.center
        desarmadorButtonCenter = desarmador.center
        llaveButtonCenter = llave.center
        microfonoButtonCenter = microfono.center
        
        usb.center = more.center
        desarmador.center = more.center
        llave.center = more.center
        microfono.center = more.center
        
        
       //cargarImagenesJSON()
        indicator.color = UIColor.cyan
        
        indicator.startAnimating()
        
        self.sceneView.delegate = self
        
        self.sceneView.autoenablesDefaultLighting = true
        
        let scene = SCNScene()
        
        sceneView.scene = scene
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        indicator.isHidden = true
        indicator.stopAnimating()
        
        cargarImagenesJSON()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        currentNode.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
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

    
    func addPortal(){
        let portalScene = SCNScene(named: "Portal.scncassets/Portal.scn")
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        
        portalNode.position = SCNVector3(0,-1,2)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        self.addPlane(nodeName: "roof", portalNode: portalNode, data: dataarriba!)
        self.addPlane(nodeName: "floor", portalNode: portalNode, data: dataabajo!)
        self.addWalls(nodeName: "backWall", portalNode: portalNode, data: datacentro!)
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, data: dataIzquierda!)
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, data: dataDerecha!)
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, data: dataFrente!)
        //self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, data: dataFrente!)
        
        
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
        currentNode.eulerAngles = SCNVector3(0,sender.rotation,0)
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
        
        
        let moviePath = "http://199.233.252.86/201811/incedetec/video/drone.mov"
        let url = URL(string: moviePath)
        let player = AVPlayer(url: url!)
        player.volume = 0.5
        print(player.isMuted)
        videoNodo = SKVideoNode(url: url!)
        
        // crear un nodo capaz de reporducir un video
        //let videoNodo = SKVideoNode(url: url!)
        //videoNodo = SKVideoNode(fileNamed: "drone.mov")
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
        videoNodo.pause()
        PlayBut.isHidden = false
        PauseBut.isHidden = true
        
    }
    
    
    //Empieza mostrar Materiales
 
    
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
    
  
    
   //ACTIVAR PORTAL
    @IBAction func portalbutton(_ sender: UIButton) {
        if bandera == false{
            //cargarImagenesJSON()
            addPortal()
            bandera = true
        }else{
            let alert = UIAlertController(title: "No puedes colocar más de un portal", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    

    //ANIMACION BOTON
    @IBAction func moreClicked(_ sender: UIButton) {
        if banderaObjetos == false{
            UIView.animate(withDuration: 0.3, animations: {
                //animation here
                self.usb.alpha = 1
                self.desarmador.alpha = 1
                self.llave.alpha = 1
                self.microfono.alpha = 1
                
                
                self.usb.center = self.usbButtonCenter
                self.desarmador.center = self.desarmadorButtonCenter
                self.llave.center = self.llaveButtonCenter
                self.microfono.center = self.microfonoButtonCenter
                
            })
            banderaObjetos = true
        }else{
           UIView.animate(withDuration: 0.3, animations: {
            
            self.usb.alpha = 0
            self.desarmador.alpha = 0
            self.llave.alpha = 0
            self.microfono.alpha = 0
            
            
            self.usb.center = self.more.center
            self.desarmador.center = self.more.center
            self.llave.center = self.more.center
            self.microfono.center = self.more.center
           })
           banderaObjetos = false
        }
        
    }
    
    //Controlar objetos
    var micBool : Bool
    var llaveBool : Bool
    var desarmadorBool : Bool
    var usbBool : Bool
    var currentNode  = SCNNode()
   var micNode  = SCNNode()
    var llaveNode  = SCNNode()
    var desarmadorNode  = SCNNode()
    var usbNode  = SCNNode()
    
    //COLOCAR OBJETOS EN ESCENA
    func addItem(selectedItem: String) {
        guard let currentFrame = self.sceneView.session.currentFrame else {return}
        
        let scene = SCNScene(named: "art.scnassets/\(selectedItem).scn")
        let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
        node.position = SCNVector3(0,0,-1)
        
        
        
        //identificar en donde se ha tocado el currentFrame
        var traduccion = matrix_identity_float4x4
        //definir un metro alejado del dispositivo
        traduccion.columns.3.z = -1.0
        
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
        node.simdScale = simd_float3(1)
        node.simdRotation = float4(90)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        currentNode = node
    }
    
    @IBAction func usbButtonAction(_ sender: UIButton) {
        if(usbBool == false){
            addItem(selectedItem: "USB")
            usbBool = true
            usbNode = currentNode
        }else{
            currentNode = usbNode
        }
    }
    
    @IBAction func desarmadorButtonAction(_ sender: UIButton) {
        if(desarmadorBool == false){
            addItem(selectedItem: "desarmador")
            desarmadorBool = true
            desarmadorNode = currentNode
        }else{
            currentNode = desarmadorNode
        }
    }
    
    @IBAction func llaveButtonAction(_ sender: UIButton) {
         if(llaveBool == false){
            addItem(selectedItem: "LlaveMecanica")
            llaveBool = true
            llaveNode = currentNode
         }else{
            currentNode = llaveNode
        }
    }
    
    @IBAction func microfonoButtonAction(_ sender: UIButton) {
        if(micBool == false){
            addItem(selectedItem: "microfono")
            micBool = true
            micNode = currentNode
        }else{
            currentNode = micNode
        }
        
        
    }
    
    
    //CARGAR IMAGENES DE JSON
    func cargarImagenesJSON(){
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
    }
    
    //MACHINE LEARNING
    
    @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
        //obtener la vista donde se va a trabajar
        let vista = sender.view as! ARSCNView
        //ubicar el toque en el centro de la vista
        let ubicacionToque = self.sceneView.center
        //obtener la imagen actual
        guard let currentFrame = vista.session.currentFrame else {return}
        //obtener los nodos que fueron tocados por el rayo
        let hitTestResults = vista.hitTest(ubicacionToque, types: .featurePoint)
        
        if (hitTestResults .isEmpty){
            //no se toco nada
            return}
        guard var hitTestResult = hitTestResults.first else{
            return
            
        }
        //obtener la imagen capturada en formato de buffer de pixeles
        let imagenPixeles = currentFrame.capturedImage
        self.hitTestResult = hitTestResult
        performVisionRequest(pixelBuffer: imagenPixeles)
    }
    
    private func performVisionRequest(pixelBuffer: CVPixelBuffer)
    {
        //inicializar el modelo de ML al modelo usado, en este caso resnet
        let visionModel = try! VNCoreMLModel(for: resnetModel.model)
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
            if error != nil {
                //hubo un error
                return}
            guard let observations = request.results else {
                //no hubo resultados por parte del modelo
                return
                
            }
            //obtener el mejor resultado
            let observation = observations.first as! VNClassificationObservation
            
            print("Nombre \(observation.identifier) confianza \(observation.confidence)")
            self.desplegarTexto(entrada: observation.identifier)
            
        }
        //la imagen que se pasará al modelo sera recortada para quedarse con el centro
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
            
        }
        
    }
    
    private func desplegarTexto(entrada: String)
    {
        
        let letrero = SCNText(string: entrada
            , extrusionDepth: 0)
        letrero.alignmentMode = kCAAlignmentCenter
        letrero.firstMaterial?.diffuse.contents = UIColor.cyan
        letrero.firstMaterial?.specular.contents = UIColor.white
        letrero.firstMaterial?.isDoubleSided = true
        letrero.font = UIFont(name: "Futura", size: 0.20)
        let nodo = SCNNode(geometry: letrero)
        nodo.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y-0.2,self.hitTestResult.worldTransform.columns.3.z )
        nodo.scale = SCNVector3Make(0.2, 0.2, 0.2)
        self.sceneView.scene.rootNode.addChildNode(nodo)
        
    }

}


extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}



