//
//  AsyncPublisherSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
import Combine

class AsyncPublisherManager {
    @Published var data: [String] = []
    func addData() async {
        try? await Task.sleep(for: .seconds(2))
        data.append("Orange")
        try? await Task.sleep(for: .seconds(2))

        data.append("Banana")
        try? await Task.sleep(for: .seconds(2))

        data.append("Pineapple")
        try? await Task.sleep(for: .seconds(2))

        data.append("Strawberry")
        try? await Task.sleep(for: .seconds(2))

        data.append("Blueberry")
        
        
    }
    
}

class AsyncPublisherViewModel: ObservableObject {
    @Published var data : [String] = []
    let manager = AsyncPublisherManager()
    var cancellables =  Set<AnyCancellable>()
    init() {
        addSubscribersAsync()
    }
    func start() async {
        await manager.addData( )
        
    }
    private func addSubscribers() {
        manager.$data
            .receive(on: DispatchQueue.main, options: nil)
            .sink { data in
                self.data = data
            }
            .store(in: &cancellables)
    }
    private func addSubscribersAsync()  {
        Task{
            for await value in manager.$data.values {
                self.data = value
            }
        }
    }
}

struct AsyncPublisherSample: View {
    @StateObject private var viewModel = AsyncPublisherViewModel()
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                ForEach(viewModel.data,id:\.self ){text in
                    
                    Text(text)
                        .font(.headline)
                }
            }
                .frame(maxWidth: .infinity)
                .background(.gray)
        }.background(Color.yellow)
        .task {
            await viewModel.start()
            
        }
    }
}

#Preview {
    AsyncPublisherSample()
}
