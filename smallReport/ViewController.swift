//
//  ViewController.swift
//  smallReport
//
//  Created by user on 2017/10/9.
//  Copyright © 2017年 tzuyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var btnMgr: UIButton!
    @IBOutlet weak var list1View: UIStackView!
    @IBOutlet weak var btnAddImg: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var list2View: UIStackView!
    @IBOutlet weak var list3View: UIStackView!
    @IBOutlet weak var flowerView: UIStackView!
    @IBOutlet weak var leafView: UIStackView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lightView: UIStackView!
    @IBOutlet weak var butterflyView: UIStackView!
    @IBOutlet weak var drawpanView: UIStackView!
    

    var imagePicker = UIImagePickerController()
    
    // For Icon
    var pan:UIPanGestureRecognizer? = nil
    var pin:UIPinchGestureRecognizer? = nil
    var rota:UIRotationGestureRecognizer? = nil
    var items:[ball] = []
    
    var recycle:[ball] = []
    var orgBound:CGRect? = nil
    var lastRnd:CGFloat = 0.0
    
    // For Line
    var lines:[[CGPoint]] = []
    var line:[CGPoint] = []
//    var recyler2:[[CGPoint]] = []
    
    var lineShape:CAShapeLayer? = nil
    var linePath:UIBezierPath? = nil
    var recyler3:[CALayer] = []
    

    class ball {
        let ballView:UIImageView = UIImageView(image: UIImage(named: "flower1"))
    }
    
    
    // 功能表
    @IBAction func doMgr(_ sender: Any) {
        list1View.isHidden = !list1View.isHidden
        list2View.isHidden = true
        list3View.isHidden = true
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
        drawpanView.isHidden = true
        
    }
    
    //從相簿新增照片
    @IBAction func addImg(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            imagePicker.modalPresentationStyle = .popover
            let popover = imagePicker.popoverPresentationController
            popover?.sourceView = sender
            
            popover?.sourceRect = btnAddImg.bounds
            popover?.permittedArrowDirections = .left
            
            show(imagePicker, sender: self)
        }
        
        hiddenListView()
        
    }
    
    //選定照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.image = img
        }
        
        dismiss(animated: true, completion: nil)
        
        items = []
        recycle = []
        recyler3 = []
        lines = []
        ball()
        lineShape = CAShapeLayer()
        lineShape!.path = nil
        
        if myView.layer.sublayers != nil {
            for s in myView.layer.sublayers!{
                if s != myView.layer.sublayers![0]{
                    s.removeFromSuperlayer()
                }
            }
        }
        
        getSize()
    }
    
    //新增圖示
    @IBAction func pickIcon(_ sender: Any) {
        list2View.isHidden = !list2View.isHidden
        list3View.isHidden = true
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
        drawpanView.isHidden = true
    }
    
    //刪除選項
    @IBAction func deleteIcon(_ sender: Any) {
        list3View.isHidden = !list3View.isHidden
        list2View.isHidden = true
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
        drawpanView.isHidden = true
    }
    
    //畫筆顏色
    @IBAction func choseDrawpan(_ sender: Any) {
        drawpanView.isHidden = !drawpanView.isHidden
        list2View.isHidden = true
        list3View.isHidden = true
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
    }
    
    //照片存檔
    @IBAction func saveImg(_ sender: Any) {
        let img = UIImage.init(view:myView)
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        hiddenListView()
    }
    
    //圖示分類
    @IBAction func flower(_ sender: Any) {
        flowerView.isHidden = false
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
    }
    
    @IBAction func leaf(_ sender: Any) {
        flowerView.isHidden = true
        leafView.isHidden = false
        lightView.isHidden = true
        butterflyView.isHidden = true
    }
    
    @IBAction func light(_ sender: Any) {
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = false
        butterflyView.isHidden = true
    }
    
    @IBAction func butterfly(_ sender: Any) {
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = false
    }
    
    //圖示按鈕
    @IBAction func addF1(_ sender: Any) {
        addIconImg(name: "flower1")
    }
    
    @IBAction func addF2(_ sender: Any) {
        addIconImg(name: "flower2")
    }
    
    @IBAction func addF3(_ sender: Any) {
        addIconImg(name: "flower3")
    }
    
    @IBAction func addF4(_ sender: Any) {
        addIconImg(name: "flower4")
    }
    
    @IBAction func addLeaf1(_ sender: Any) {
        addIconImg(name: "leaf1")
    }
    
    @IBAction func addLeaf2(_ sender: Any) {
        addIconImg(name: "leaf2")
    }
    
    @IBAction func addLeaf3(_ sender: Any) {
        addIconImg(name: "leaf3")
    }
    
    @IBAction func addLeaf4(_ sender: Any) {
        addIconImg(name: "leaf4")
    }
    
    @IBAction func addLight1(_ sender: Any) {
        addIconImg(name: "stars")
    }
    
    @IBAction func addLight2(_ sender: Any) {
        addIconImg(name: "moon")
    }
    
    @IBAction func addLight3(_ sender: Any) {
        addIconImg(name: "lightning")
    }
    
    @IBAction func addLight4(_ sender: Any) {
        addIconImg(name: "fullmoon")
    }
    
    @IBAction func addButterfly1(_ sender: Any) {
        addIconImg(name: "butterfly1")
    }
    
    @IBAction func addButterfly2(_ sender: Any) {
        addIconImg(name: "butterfly2")
    }
    
    @IBAction func addButterfly3(_ sender: Any) {
        addIconImg(name: "butterfly3")
    }
    
    @IBAction func addButterfly4(_ sender: Any) {
        addIconImg(name: "butterfly4")
    }
    
    //加圖示&手勢函數
    private func addIconImg(name:String){
        hiddenListView()
        lineShape = CAShapeLayer()
        recycle = []
        recyler3 = []
        items += [ball()]
        items[items.count-1].ballView.image = UIImage(named: name)
        items[items.count-1].ballView.frame = CGRect(x: 100, y: 100, width: 40, height: 40)
//        myView.addSubview(items[items.count-1].ballView)
        myView.layer.addSublayer(items[items.count-1].ballView.layer)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(moveItem))
        myView.addGestureRecognizer(pan!)
        
        pin = UIPinchGestureRecognizer(target: self, action: #selector(zoomItem))
        myView.addGestureRecognizer(pin!)
        orgBound = items[items.count-1].ballView.bounds
        
        rota = UIRotationGestureRecognizer(target: self, action: #selector(rotateItem))
        myView.addGestureRecognizer(rota!)
        
    }
    
    //移動圖示
    @objc func moveItem(_ sender:UIPanGestureRecognizer){
        for i in 0 ..< sender.numberOfTouches{
            let p = sender.location(ofTouch: i, in: myView)
            items[items.count-1].ballView.center = p
        }
    }
    
    //縮放圖示
    @objc func zoomItem(_ sender:UIPinchGestureRecognizer){
        
        let size = CGSize(width: (orgBound?.size.width)!*sender.scale, height: (orgBound?.size.height)!*sender.scale)
        items[items.count-1].ballView.bounds.size = size
        
        if sender.state == UIGestureRecognizerState.ended{
            orgBound = items[items.count-1].ballView.bounds
        }
    }
    
    //旋轉圖示
    @objc func rotateItem(_ sender:UIRotationGestureRecognizer){
        items[items.count-1].ballView.transform = items[items.count-1].ballView.transform.rotated(by: sender.rotation-lastRnd)
        lastRnd = sender.rotation
    }
    
    
    //選藍色筆
    @IBAction func bluePan(_ sender: Any) {
        hiddenListView()
        lines = []
        lineShape = CAShapeLayer()
        pan = UIPanGestureRecognizer(target: self, action: #selector(drawLine))
        myView.addGestureRecognizer(pan!)
    }
    
    //選紅色筆
    @IBAction func redPan(_ sender: Any) {
        hiddenListView()
        lines = []
        lineShape = CAShapeLayer()
        pan = UIPanGestureRecognizer(target: self, action: #selector(drawLine2))
        myView.addGestureRecognizer(pan!)
    }
    
    //選黃色筆
    @IBAction func yellowPan(_ sender: Any) {
        hiddenListView()
        lines = []
        lineShape = CAShapeLayer()
        pan = UIPanGestureRecognizer(target: self, action: #selector(drawLine3))
        myView.addGestureRecognizer(pan!)
    }
    
    //選綠色筆
    @IBAction func greenPan(_ sender: Any) {
        hiddenListView()
        lines = []
        lineShape = CAShapeLayer()
        pan = UIPanGestureRecognizer(target: self, action: #selector(drawLine4))
        myView.addGestureRecognizer(pan!)
    }
    
    //選咖啡色筆
    @IBAction func coffeePan(_ sender: Any) {
        hiddenListView()
        lines = []
        lineShape = CAShapeLayer()
        pan = UIPanGestureRecognizer(target: self, action: #selector(drawLine5))
        myView.addGestureRecognizer(pan!)
    }
    
    //畫藍色
    @objc func drawLine(_ sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            let p = sender.location(in: myView)
            ball()
            lineShape = CAShapeLayer()
            lineShape!.strokeColor = UIColor.blue.cgColor
            lineShape!.fillColor = nil
            lineShape!.lineWidth = 2.0
            linePath = UIBezierPath()
            
            line = [p]
            lines += [line]
            
            myView.layer.addSublayer(lineShape!)
            
            recyler3 = []
        }
        
        
        if sender.state == UIGestureRecognizerState.changed{
            let p = sender.location(in: myView)
            lines[lines.count-1] += [p]
            changePath()
        }
        
    }
    
    //畫紅色
    @objc func drawLine2(_ sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            let p = sender.location(in: myView)
            ball()
            lineShape = CAShapeLayer()
            lineShape!.strokeColor = UIColor.red.cgColor
            lineShape!.fillColor = nil
            lineShape!.lineWidth = 2.0
            linePath = UIBezierPath()
            
            line = [p]
            lines += [line]
            
            myView.layer.addSublayer(lineShape!)
            recyler3 = []
        }
        
        
        if sender.state == UIGestureRecognizerState.changed{
            let p = sender.location(in: myView)
            lines[lines.count-1] += [p]
            changePath()
        }
        
    }
    
    //畫黃色
    @objc func drawLine3(_ sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            let p = sender.location(in: myView)
            ball()
            lineShape = CAShapeLayer()
            lineShape!.strokeColor = UIColor.yellow.cgColor
            lineShape!.fillColor = nil
            lineShape!.lineWidth = 2.0
            linePath = UIBezierPath()
            
            line = [p]
            lines += [line]
            
            myView.layer.addSublayer(lineShape!)
            recyler3 = []
        }
        
        
        if sender.state == UIGestureRecognizerState.changed{
            let p = sender.location(in: myView)
            lines[lines.count-1] += [p]
            changePath()
        }
        
    }
    
    //畫綠色
    @objc func drawLine4(_ sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            let p = sender.location(in: myView)
            ball()
            lineShape = CAShapeLayer()
            lineShape!.strokeColor = UIColor.green.cgColor
            lineShape!.fillColor = nil
            lineShape!.lineWidth = 2.0
            linePath = UIBezierPath()
            
            line = [p]
            lines += [line]
            
            myView.layer.addSublayer(lineShape!)
            recyler3 = []
        }
        
        
        if sender.state == UIGestureRecognizerState.changed{
            let p = sender.location(in: myView)
            lines[lines.count-1] += [p]
            changePath()
        }
        
    }
    
    //畫咖啡色
    @objc func drawLine5(_ sender:UIPanGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.began{
            let p = sender.location(in: myView)
            ball()
            lineShape = CAShapeLayer()
            lineShape!.strokeColor = UIColor.brown.cgColor
            lineShape!.fillColor = nil
            lineShape!.lineWidth = 2.0
            linePath = UIBezierPath()
            
            line = [p]
            lines += [line]
            
            myView.layer.addSublayer(lineShape!)
            recyler3 = []
        }
        
        
        if sender.state == UIGestureRecognizerState.changed{
            let p = sender.location(in: myView)
            lines[lines.count-1] += [p]
            changePath()
        }
        
    }
    
    //改變路徑
    private func changePath(){
        
        for line in lines {
            linePath!.move(to: line[0])
            
            for i in 0..<line.count{
                linePath!.addLine(to: line[i])
            }
        }
        
        lineShape!.path = linePath!.cgPath
    }
    
    //復原
    @IBAction func undoLine(_ sender: Any) {
        hiddenListView()
        
        if myView.layer.sublayers != nil {
            for s in myView.layer.sublayers!{
                if s != myView.layer.sublayers![0]{
                    if s == myView.layer.sublayers?.last{
                        recyler3 += [s]
                        s.removeFromSuperlayer()
                    }
                }
            }
        }
    }
    
    //取消復原
    @IBAction func redoLine(_ sender: Any) {
        hiddenListView()
        
        if recyler3.count > 0 {
            myView.layer.addSublayer(recyler3[recyler3.count-1])
            recyler3.remove(at: recyler3.count-1)
        }
    }
    
    //刪除全部圖示&線
    @IBAction func deleteAllLine(_ sender: Any) {
        hiddenListView()
        items = []
        recycle = []
        recyler3 = []
        lines = []
        ball()
        lineShape = CAShapeLayer()
        
        lineShape!.path = nil
        
        if myView.layer.sublayers != nil {
            for s in myView.layer.sublayers!{
                if s != myView.layer.sublayers![0] {
                    s.removeFromSuperlayer()
                }
            }
        }
    }
    
    //隱藏View
    private func hiddenListView(){
        list1View.isHidden = true
        list2View.isHidden = true
        list3View.isHidden = true
        flowerView.isHidden = true
        leafView.isHidden = true
        lightView.isHidden = true
        butterflyView.isHidden = true
        drawpanView.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenListView()
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(moveBtn))
        view.addGestureRecognizer(pan!)
        
        getSize()
    }
    
    //移動功能表
    @objc func moveBtn(_ sender:UIPanGestureRecognizer){
        for i in 0 ..< sender.numberOfTouches{
            let p = sender.location(ofTouch: i, in: view)
            btnMgr.center = p
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        getSize()
    }
    
    
    private func getSize(){
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        var RW:CGFloat = 0
        var RH:CGFloat = 0
        if w > h {
            RW = w / 4
            RH = h / 3
            let R = (RW > RH) ? RH : RW
            myView.bounds.size.width = R * 4
            myView.bounds.size.height = R * 3
            myView.center.x = w / 2
            myView.center.y = h / 2
            imgView.center.x = w / 2 - 150
            imgView.center.y = h / 2
            
        }else{
            RW = w / 3
            RH = h / 4
            let R = (RW > RH) ? RH : RW
            myView.bounds.size.width = R * 3
            myView.bounds.size.height = R * 4
            myView.center.x = w / 2
            myView.center.y = h / 2
            imgView.center.x = w / 2
            imgView.center.y = h / 2 - 90
            
        }
        imgView.frame = CGRect(x: 0, y: 0, width: myView.bounds.size.width, height: myView.bounds.size.height)
        let wRate = imgView.bounds.size.width / imgView.image!.size.width
        let hRate = imgView.bounds.size.height / imgView.image!.size.height
        let scale = (wRate > hRate) ? hRate : wRate
        let imageW = scale * imgView.image!.size.width
        let imageH = scale * imgView.image!.size.height
        imgView.frame.size.width = imageW
        imgView.frame.size.height = imageH
        
        myView.bounds.size = imgView.frame.size
    }
    
    
}

extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

