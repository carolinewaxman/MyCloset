import CoreML
import UIKit

func detectCategory(from image: UIImage) -> String {
    guard let inputArray = imageToMultiArray(image) else {
        print("Failed to process image")
        return "unknown"
    }
    
    do {
        let classifier = try ClothingClassifier(configuration: MLModelConfiguration())
        let input = ClothingClassifierInput(mobilenetv2_1_00_224_input: inputArray)
        let prediction = try classifier.prediction(input: input)
        let values = prediction.Identity
        if let (bestLabel, _) = values.max(by: { $0.value < $1.value }) {
            return bestLabel
        }

    } catch {
        print("Model failed to make prediction: \(error.localizedDescription)")
    }
    return "unknown"
}
