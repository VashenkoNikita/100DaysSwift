//
//  ViewController.swift
//  Project 13
//
//  Created by User on 04.12.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var intensBlur: UISlider!
    
    var currentImgae:UIImage!
    
    var context:CIContext!
    var currentFilter:CIFilter!
    
    @IBOutlet var changeFilters: UIButton!
    @IBOutlet var changeFilter1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "YACIFP"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    @objc func importPicture(action:UIAlertAction){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func changeFIlter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    @IBAction func changeFilter1(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter1))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    func setFilter(action:UIAlertAction){
        guard currentImgae != nil else{return}
        guard let actionTitle = action.title else {return}
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImgae)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        changeFilters.titleLabel?.text = actionTitle
        applyProcessing()
        
    }
    func setFilter1(action:UIAlertAction){
        guard currentImgae != nil else{return}
        guard let actionTitle = action.title else {return}
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImgae)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        changeFilters.titleLabel?.text = actionTitle
        applyProcessing()
        
    }
    @IBAction func save(_ sender: Any) {
        if imageView.image != nil{
            UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(images(_:didFinishSavingWithError:contextInfo:)), nil)
        } else if imageView.image == nil{
            let ac = UIAlertController(title: "Error", message: "Image is not found!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            ac.addAction(UIAlertAction(title: "Add image?", style: .cancel, handler: importPicture))
            present(ac, animated: true)
        }
        

    }
    @objc func images(_ image:UIImage, didFinishSavingWithError error:Error?, contextInfo:UnsafeRawPointer){
        if let error = error{
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }else{
            let ac = UIAlertController(title: "Saved", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    @IBAction func changeIntensity(_ sender: Any) {
        applyProcessing()
    }
    @IBAction func changeIntensBlur(_ sender: Any) {
        applyProcessing()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImgae = image
        let beginImgae = CIImage(image: currentImgae)
        currentFilter.setValue(beginImgae, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey){currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey){currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey){currentFilter.setValue(CIVector(x: currentImgae.size.width/2, y: currentImgae.size.height/2), forKey: kCIInputCenterKey)}
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    

}

