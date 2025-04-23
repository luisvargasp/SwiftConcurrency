//
//  TaskSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 22/04/25.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var image : UIImage?=nil
    @Published var image2 : UIImage?=nil
    
    func fetchImage() async {
        
        do {
            guard let url = URL(string: "https://fastly.picsum.photos/id/557/1024/1024.jpg?hmac=X7i7LI4xE60C0fl4cXvvyebsWdDakb1j7ncXRW_zFMs") else { return }
            
            
            let (data , response ) =   try await URLSession.shared.data(from: url, delegate:nil)
            guard
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 304 else {
                return
            }
            self.image = image
        }catch{
            
        }
        
    }
    func fetchImage2() async {
        
        do {
            guard let url = URL(string: "https://fastly.picsum.photos/id/228/4096/4096.jpg?hmac=1FWPw_fhM9tIT202kv3SNL5lOKPL_yeum8m1hV76vuk") else { return }
            
            
            let (data , response ) =   try await URLSession.shared.data(from: url, delegate:nil)
            guard
                let image = UIImage(data: data),
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 304 else {
                return
            }
            self.image2 = image
        }catch{
            
        }
        
    }
}

struct TaskSample: View {
    @ObservedObject var viewModel = TaskViewModel()
    var body: some View {
        
        VStack(spacing : 40 ){
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( ).frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( ).frame(width: 200, height: 200)
            }
        }.task{
            await viewModel.fetchImage()
        }
        
        .onAppear{
            Task{
                await viewModel.fetchImage()
                await viewModel.fetchImage2()
            }
            
//            Task(priority: .low){
//                print("LOW \(Thread.current) \(Task.currentPriority)")
//                
//            }
//            
//            Task(priority: .medium){
//                print("MEDIUM \(Thread.current) \(Task.currentPriority)")
//                
//            }
//            
//            Task(priority: .high){
//                try await Task.sleep(for: .seconds(1))
//                print("HIGH \(Thread.current) \(Task.currentPriority)")
//                
//            }
//            Task(priority: .background){
//                print("BACKGROUND \(Thread.current) \(Task.currentPriority)")
//                
//            }
//            Task(priority: .utility){
//                print("UTILITY \(Thread.current) \(Task.currentPriority)")
//                
//            }
//            Task(priority: .userInitiated){
//                print("USER INITIATED \(Thread.current) \(Task.currentPriority)")
//                 
//            }
//            
            
            
            Task(priority: .userInitiated){
                print("USER INITIATED \(Thread.current) \(Task.currentPriority)")
                Task.detached{
                    print("Child Task") //inherit properties from parent
                }
            }
            
            let task = Task {
                print("Initialiing task...")
                 try await Task.sleep(for: .seconds(2))
                print("Task completed.")
            }
            task.cancel()
            
            
            
        }
        
    }
}

#Preview {
    TaskSample()
}
