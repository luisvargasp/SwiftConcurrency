//
//  TaskGroupSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 23/04/25.
//

import SwiftUI

class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    
    let url =  "https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs"
    
    func loadImageAsync(url :String) async -> UIImage {
        do {
            guard let url = URL(string :"https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs" ) else {
                return UIImage(systemName: "xmark")!
            }
            try? await Task.sleep(for: .seconds(2))
            
            
            let (data , response ) =   try await URLSession.shared.data(from: url, delegate:nil)
            guard
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 304 else {
                return UIImage(systemName: "xmark")!
            }
            return  image
        }catch{
            return UIImage(systemName: "xmark")!
            
        }
    }
    func loadImages() async{
        async let image1 = self.loadImageAsync(url: url)
        async let image2 = self.loadImageAsync(url: url)
        async let image3 = self.loadImageAsync(url: url)
        async let image4 = self.loadImageAsync(url: url)
        async let image5 = self.loadImageAsync(url: url)
        async let image6 = self.loadImageAsync(url: url)
        async let image7 = self.loadImageAsync(url: url)
        async let image8 = self.loadImageAsync(url: url)
        async let image9 = self.loadImageAsync(url: url)
        async let image10 = self.loadImageAsync(url: url)
        
        await images.append(contentsOf: [image1,image2,image3,image4,image5,
                                        image6,image7,image8,image9,image10])
    }
    func loadImagesWithTaskGroup() async{
        await withTaskGroup(of: UIImage.self) { group in
            for _ in 0..<20 {
                group.addTask { [self] in
                    await self.loadImageAsync(url: url)
                }
            }
            for  await image in group {
                self.images.append( image)
            }
        }
    }

}

struct TaskGroupSample: View {
    @StateObject var viewModel=TaskGroupViewModel()
    let url = URL(string :"https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs" )
    let colums = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums){
                    ForEach(viewModel.images , id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit( )
                            .frame(height: 75)
                    }
                    
                }
            }.navigationTitle( "Task Group Sample" )
                .task {
                    await viewModel.loadImagesWithTaskGroup()
                }
            
        }
    }
}

#Preview {
    TaskGroupSample()
}
