//
//  PhotoPickerSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 27/04/25.
//

import SwiftUI
import PhotosUI

@MainActor
class PhotoPickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var  imageSelection: PhotosPickerItem? = nil {
        didSet{
            setImage(selection: imageSelection)
            
        }
        
    }
    
    @Published var selectedImages: [UIImage] = []
    @Published var  imageSelections: [PhotosPickerItem] = [] {
        didSet{
            setImages(selections: imageSelections)
            
        }
        
    }
    private func setImage(selection : PhotosPickerItem?){
        guard let selection = selection else { return
        }
        Task{
            if let data = try? await selection.loadTransferable(type: Data.self) {
                
                if let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                }
                
            }
        }
        
    }
    private func setImages(selections : [PhotosPickerItem]){
        
        Task{
            var images: [UIImage] = []
            
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                    
                }
                
            }
            self.selectedImages.append(contentsOf: images)
            
        }
        
    }
    
    
    
}

struct PhotoPickerSample: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    var body: some View {
        VStack(spacing:40){
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
            }
            PhotosPicker(selection: $viewModel.imageSelection
                         ,matching : .images){
                Text("Open phote picker")
            }
            if viewModel.selectedImages.count > 0 {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(viewModel.selectedImages,id: \.self){ image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50,height: 50)
                            
                        }
                    }
                    
                    
                }
            }
            PhotosPicker(selection: $viewModel.imageSelections
                         ,matching : .images){
                Text("Open phote picker")
            }
            
        }
        
    }
}

#Preview {
    PhotoPickerSample()
}
