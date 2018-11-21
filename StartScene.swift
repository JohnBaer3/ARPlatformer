//
//  StartScene.swift
//  WaluigiAR
//
//  Created by John Baer on 11/15/18.
//  Copyright © 2018 John Baer. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import AVFoundation
import Vision

//Analyzes photo colors
extension UIImage {
    public func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}


class StartScene : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var placeArrD = [CGPoint]()
    
    var imager : UIImage!
    var heightInPoints : CGFloat = 0
    var heightInPixels : CGFloat = 0
    var widthInPoints : CGFloat = 0
    var widthInPixels : CGFloat = 0
    
    
//    func setupCaptureSession() {
//        // creates a new capture session
//        let captureSession = AVCaptureSession()
//    }
    

//Make the photo taking full-screen, not cropped
    
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
            
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imager = image
        self.uploadClick(UIButton.self)
    }
    
    
    @IBAction func uploadClick(_ sender: Any) {
        //Goes through all the pixels of the photo
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let red2: CGFloat = 0.3
        let green2: CGFloat = 0.3
        let blue2: CGFloat = 0.3
        
        
        //heightInPixels, widthInPixels isn't working... I have to change this - make this work properly
        
        heightInPoints = imager!.size.height
        heightInPixels = heightInPoints * imager!.scale
        
        widthInPoints = imager!.size.width
        widthInPixels = widthInPoints * imager!.scale
        
        //Taking an image DOES change the size of imager from simply using the uploaded photo
        //Next check... is the image uploaded's width the same as the width recorded here? Aka: 750
        
        print(heightInPoints)
        print(widthInPoints)
        print(heightInPixels)
        print(widthInPixels)
        
        
//Have to get the right height for the image
        for i in stride(from: 0, through: Int(heightInPixels/2), by: 5){
            for n in stride(from: 0, through: Int(widthInPixels), by: 5){
                //                print(image?.getPixelColor(pos: CGPoint(x:i, y:n)))
                //                image?.getPixelColor(pos: CGPoint(x:i, y:n)).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                let pixelColor : UIColor = (imager?.getPixelColor(pos: CGPoint(x:n, y:i)))!
                pixelColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                //How to get accurate readings for if something is darker color than gray
                //The lower the color, the darker the color... do something with that
                
                if(red < red2 || green < green2 || blue < blue2){
                    placeArrD.append(CGPoint(x:n, y:i))
                }
                
                
                //                if(red > 60 && green > 60 && blue > 60){
                //                    placeArrD.append(CGPoint(x:i, y:n))
                //                }
            }
        }
        
        print("done!")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupCaptureSession()

        imager = UIImage(named: "blackWhite2")
        
        heightInPoints = imager!.size.height
        heightInPixels = heightInPoints * imager!.scale
        
        widthInPoints = imager!.size.width
        widthInPixels = widthInPoints * imager!.scale
        
        self.uploadClick(UIButton.self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameViewController = segue.destination as? GameViewController {
            gameViewController.placeArr = placeArrD
        }
    }
}
