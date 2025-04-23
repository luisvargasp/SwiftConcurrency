//
//  DownloadImageAsync.swift
//  SwiftConcurrency
//
//  Created by FerVP on 22/04/25.
//

import SwiftUI
import Combine
class ImageDownloader {
    let url = URL(string: "https://fastly.picsum.photos/id/1016/200/200.jpg?hmac=VXVyuNaCgLl1UAdVez4gIo7AzMowZxMZVlIKlHMjgBw")!
    func downloadWithEscaping(completion: @escaping (_ image:UIImage?,_ error:Error?) -> Void)  {
        URLSession.shared.dataTask(with:url) {data , response,error in
            guard let data = data ,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            
            response.statusCode >= 200 && response.statusCode < 304
            
            else {
                completion(nil,error)
                let response = response as? HTTPURLResponse
                print(response?.statusCode)

                print("Error downloading image")
                return
            }
            print(response.statusCode)
            print("Downloaded image")
            completion(image,nil)
            
        }.resume()
    }
    func downloadWithCombine()  -> AnyPublisher<UIImage?,Error> {
        URLSession.shared.dataTaskPublisher(for:url)
            .map {
                data ,response  -> UIImage?  in
                
                guard
                      let image = UIImage(data: data),
                      let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 304
                else {
                    return nil
                }
                return image
            }
            .mapError(  {$0})
            .eraseToAnyPublisher()
    }
    func downloadWithAsync() async   throws  -> UIImage?{
        
        do{
            let (data , response ) =   try await URLSession.shared.data(from: url, delegate:nil)
            guard
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 304 else {
                return nil
                }
            return image
            
        }catch {
            throw error
        }
        
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage?
    
    let imageDownloader = ImageDownloader()
    
    var cancellables =  Set<AnyCancellable>()
    init()  {
        Task{
            print("Before")
            Task{
                await fetchImageWithAsync()
            }
            print("after")

        }
    }
    func fetchImage() {
        imageDownloader.downloadWithEscaping { [weak self]image, error in
            DispatchQueue.main.async {
                if let image = image {
                    self?.image = image
                }
            }
            
        }
    }
    func fetchImageCombine() {
        imageDownloader.downloadWithCombine()
            .sink {_ in
                
            }receiveValue: { [weak self ]image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.image = image
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    func fetchImageWithAsync() async  {
        
        let image = try? await imageDownloader.downloadWithAsync()
        if let image = image  {
            print("Printing image")
            self.image = image
        }
        
    }
}

struct DownloadImageAsync: View {
    @StateObject var viewModel =  DownloadImageAsyncViewModel()
    var body: some View {
        ZStack{
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( )
                    .frame(width: 200, height: 200)
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
