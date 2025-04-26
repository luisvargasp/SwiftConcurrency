//
//  MVVMAsyncSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI

final class MyManagerClass {
    func getData() async throws -> String {
        "Some data"
    }
    
}
actor MyManagerActor {
    func getData() async throws -> String {
        "Some data"
    }
    
}
final class MVVMAsyncViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    private var tasks :[Task<Void, Never>] = []
    @Published private(set) var data:String = "Initial data"
    
    func onButtonClick()  {
        let task = Task{
            do{
                
                data = try await managerClass.getData()
            }catch {
                print(error.localizedDescription)
            }
            
        }
        tasks.append(task)
        
    }
    func cancelAllTasks()  {
        tasks.forEach{task in
            task.cancel()
            
        }
        tasks.removeAll()
    }
    
}

struct MVVMAsyncSample: View {
    @StateObject var viewModel = MVVMAsyncViewModel()
    var body: some View {
        VStack{
            Button(viewModel.data){
                viewModel.onButtonClick()
            }
        }
        .onDisappear {
            viewModel.cancelAllTasks()
        }
    }
}

#Preview {
    MVVMAsyncSample()
}
