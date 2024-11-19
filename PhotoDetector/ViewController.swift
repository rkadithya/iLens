//
//  ViewController.swift
//  PhotoDetector
//
//  Created by apple on 18/11/24.
//

import UIKit
import CoreML
import Vision
import Foundation

class ViewController: UIViewController{
    
    static let shared = ViewController()
    var imagesArr = [UIImage]()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    

    let captureButton : UIButton = {
        let button = UIButton()
        button.setTitle("Capture", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    let uploadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Upload from Photos", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    let resetButton : UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iLens"
        view.addSubview(captureButton)
        view.addSubview(uploadButton)
        
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonHeight: CGFloat = 50
        let buttonSpacing: CGFloat = 10
        let labelHeight: CGFloat = 100  // Adjust this as needed
        captureButton.frame = CGRect(x: 20, y: view.frame.height / 2, width: view.frame.width - 40, height: buttonHeight)
        uploadButton.frame = CGRect(x: 20, y: captureButton.frame.maxY + buttonSpacing, width: view.frame.width - 40, height: buttonHeight)
        
    }

    @objc private func captureImage(){
        if imagesArr.count > 0{
            imagesArr.removeAll()
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType =  .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        
    }
    
    @objc private func uploadImage(){
        if imagesArr.count > 0{
            imagesArr.removeAll()
        }
            let imagePickerView = UIImagePickerController()
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.delegate = self
            present(imagePickerView, animated: true)
      
    }
    

}
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imagesArr.append(image)
            dismiss(animated: true)
            if let image = imagesArr.first{
                let vc = ResultViewController()
                vc.selectedImage = image
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
                
            }
        }
    }
}
