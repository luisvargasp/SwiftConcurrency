//
//  StrongWeajSelfSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
final class DataService {
    func getData() async -> String {
        return "Updated data"
        
    }
}
final class StrongWeakSelfViewModel: ObservableObject {
    @Published var data = "Some title"
    let dataService = DataService()
    private var task : Task<Void, Never>? = nil
    //strong reference
    func fetchData()  {
        Task{
            data =  await dataService.getData()
        }
    }
    func cancelTask() {
        task?.cancel()
        task = nil
    }
    //strong reference

    func fetchData2()  {
        Task{
            self.data =  await dataService.getData()
        }
    }
    //strong reference

    func fetchData3()  {
        Task{[self] in
            self.data =  await dataService.getData()
        }
    }
    //weak reference
    func fetchData4()  {
        Task{[weak self] in
            if let data = await  self?.dataService.getData()  {
                self?.data = data
                
            }
        }
    }
    //no need to manage refrences
    func fetchData5()  {
       task =  Task{[self] in
            self.data =  await dataService.getData()
        }
    }
    
    
    
    
}

struct StrongWeakSelfSample: View {
    @StateObject private var viewModel = StrongWeakSelfViewModel()
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.fetchData()
            }
            .onDisappear{
                viewModel.cancelTask()
                
            }
    }
}

#Preview {
    StrongWeakSelfSample()
}
