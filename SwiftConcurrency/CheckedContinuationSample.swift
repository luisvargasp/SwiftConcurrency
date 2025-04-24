//
//  CheckedContinuationSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 23/04/25.
//

import SwiftUI
class CheckedContinuationViewModel: ObservableObject {
    
    @Published var image:UIImage?=nil
    
    func getImage() async{
        guard let url = URL(string :"https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs" ) else {
            return
        }
        
        do {
            let data = try await getData2(url: url)
            
            if let image = UIImage(data: data){
                self.image = image
            }
            
        }catch{
            print(error)
            
        }
        
    }
    
    func getData(url:URL) async throws -> Data{
        do{
            let (data,_) = try await URLSession.shared.data(from: url)
            return data
            
        }catch{
            throw error
            
        }
        
    }
    func getData2(url:URL) async throws -> Data{
        
        return    try await withCheckedThrowingContinuation{continuation in
            URLSession.shared.dataTask(with: url)  {data,response,error in
                
                if let data = data{
                    continuation.resume(returning: data)
                }else{
                    continuation.resume(throwing:URLError(.badServerResponse))
                }
            }.resume()
        }
        
    }
    
}

struct CheckedContinuationSample: View {
    @StateObject var viewModel: CheckedContinuationViewModel = .init()
    var body: some View {
        ZStack{
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
            
        }.task {
            await viewModel.getImage()
        }
    }
}

#Preview {
    CheckedContinuationSample()
}
