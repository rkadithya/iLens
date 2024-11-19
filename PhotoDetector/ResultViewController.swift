//
//  ResultViewController.swift
//  PhotoDetector
//
//  Created by apple on 18/11/24.
//

import Foundation
import UIKit
import CoreML
import Vision

class ResultViewController:UIViewController{
    
    var resultArr = [String]()
    var selectedImage: UIImage?

    let infoTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let inputImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    let closeButton : UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19, weight: .semibold)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoTableView)
        view.addSubview(inputImageView)
        view.addSubview(closeButton)

        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.rowHeight = UITableView.automaticDimension
        infoTableView.estimatedRowHeight = 44
        
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        if let image = selectedImage{
            inputImageView.image = image
            inputImageView.contentMode = .scaleAspectFit
            recognizeImage(image)
        }

    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        inputImageView.frame = CGRect(x: 30, y: 60, width: view.frame.width - 60, height: 300)
        infoTableView.frame = CGRect(x: 20, y: inputImageView.frame.height  + inputImageView.frame.origin.y, width: view.frame.width - 40, height: view.frame.height - 450)
        closeButton.frame = CGRect(x: 20, y: infoTableView.frame.height  + infoTableView.frame.origin.y, width: view.frame.width - 40, height: 50)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
       
    }
    
    @objc private func dismissVC(){
        ViewController.shared.imagesArr.removeAll()
        inputImageView.image = nil
      dismiss(animated: true)
    }
    func recognizeImage(_ image: UIImage) {
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }
        inputImageView.image = image
        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { return }

            // Format the results into a readable string
            let topResults = results.prefix(5).map { result in
                "\(result.identifier): \(String(format: "%.2f", result.confidence * 100))%"
            }.joined(separator: "\n")

            // Update the label on the main thread
            DispatchQueue.main.async {
                self?.resultArr.append(topResults)
                self?.infoTableView.reloadData()
                    
            }
        }

        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    func showResult(text: String) {
            print("Adding text to resultArr: \(text)")  // Debug print
            self.resultArr.append(text)
            print("resultArr count: \(self.resultArr.count)")  // Debug print
            self.infoTableView.reloadData()
        
    }
    
}

extension ResultViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0  // Allow unlimited lines
        cell.textLabel?.text = resultArr[indexPath.row]
        return cell
    }

}
