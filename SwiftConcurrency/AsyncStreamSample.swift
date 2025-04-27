//
//  AsyncStreamSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 27/04/25.
//

import SwiftUI


class AsyncStreamDataManager {
    func getData(completion : @escaping (_ value : Int)->Void){
        let items : [Int] = Array(1...30)
       for item in items {
           DispatchQueue.main.asyncAfter(deadline: .now()+Double(item)){
               completion(item)
           }
        }
    }
    
    func getAsyncDataStream() -> AsyncStream<Int>{
        AsyncStream(Int.self){continuation  in
            self.getData(){value in
                continuation.yield(value)
            }
        }
    }
}
@MainActor
class AsyncStreamViewModel: ObservableObject {
    let manager : AsyncStreamDataManager = AsyncStreamDataManager()
    @Published var currentNumber : Int = 0
    func onViewDidAppear(){
//        manager.getData(){ [weak self]value in
//            self?.currentNumber = value
//        }
        
       Task {
            for await number in self.manager.getAsyncDataStream(){
                self.currentNumber = number
            }
        }
    }
}

struct AsyncStreamSample: View {
    @StateObject var viewModel : AsyncStreamViewModel = AsyncStreamViewModel()
    
    
    var body: some View {
        Text(viewModel.currentNumber.description)
        .onAppear{
            viewModel.onViewDidAppear()
        }
    }
}

#Preview {
    AsyncStreamSample()
}
