//import Foundation
//import UIKit
//import CoreML
//import Vision
//
//final class Model{
//   static let shared = Model()
//    var result : String?
//
//    
//    func recognizeImage(_ image: UIImage) {
//        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else { return }
//
//        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
//            guard let results = request.results as? [VNClassificationObservation] else { return }
//
//            // Format the results into a readable string
//            let topResults = results.prefix(5).map { result in
//                "\(result.identifier): \(String(format: "%.2f", result.confidence * 100))%"
//            }.joined(separator: "\n")
//
//            // Update the label on the main thread
//            DispatchQueue.main.async {
//                self?.result = topResults
//                ViewController.shared.showResult(text: topResults)
//                
//            }
//        }
//
//        guard let cgImage = image.cgImage else { return }
//        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//        try? handler.perform([request])
//    }
//
//}
//
