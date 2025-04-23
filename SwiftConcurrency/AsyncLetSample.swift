//
//  AsyncLetSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 23/04/25.
//

import SwiftUI

struct AsyncLetSample: View {
    @State private var uiImages : [UIImage] = []
    let url = URL(string :"https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs" )
    let colums = [GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums){
                    ForEach(uiImages , id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit( )
                            .frame(height: 100)
                    }
                    
                }
            }.navigationTitle( "AsyncLet Sample" )
                .onAppear {
                    
                    Task{
                        
                        async  let image1 =  loadImageAsync()
                        async  let image2 =  loadImageAsync()
                        async  let image3 =  loadImageAsync()
                        async  let image4 =  loadImageAsync()
                        async  let image5 =  loadImageAsync()
                        async  let image6 =  loadImageAsync()
                        async  let image7 =  loadImageAsync()
                        async  let image8 =  loadImageAsync()
                        async  let image9 =  loadImageAsync()
                        async  let image10 = loadImageAsync()
                        
                        
                        //let image4 = await loadImageAsync()
                        await uiImages.append(contentsOf: [
                            image1,image2,image3,image4,image5,image6,image7,image8,image9,image10
                        ])
                        
                    }
                    
                }
        }
    }
    
    func loadImageAsync() async -> UIImage {
        do {
            guard let url = url  else {
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
}

#Preview {
    AsyncLetSample()
}
