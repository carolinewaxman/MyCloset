import SwiftUI
import CoreML
import PhotosUI
import UIKit

public struct ObjectDetectionView: View {
    @State private var detectedObjects: [String] = []
    @State private var image: UIImage? = UIImage(named: "sample_image")
    @State private var isShowingImagePicker = false
    @State private var isCamera = false
    
    public var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .onAppear {
                        let result = detectCategory(from: image)
                        detectedObjects = [result]
                    }
            } else {
                TextStyle(text: "No image selcted", color: .black)
            }
            
            HStack {
                Button("Take Photo") {
                    isCamera = true
                    isShowingImagePicker = true
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                
                Button("Upload Photo") {
                    isCamera = false
                    isShowingImagePicker = true
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            
            List(detectedObjects, id: \.self) { object in
                Text(object)
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
        ImagePicker(image: $image, useCamera: isCamera)
        }
        .onChange(of: image)  { newImage in
            if let img = newImage {
                let result = detectCategory(from: img)
                detectedObjects = [result]
            }
        }
        .navigationTitle("Clothing Detection")
    }
}
