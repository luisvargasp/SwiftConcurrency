//
//  AsyncAwaitSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 22/04/25.
//

import SwiftUI
class AsyncAwaitViewModel : ObservableObject {
    @Published var data : [String] = []
//    func addTitle1(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//           
//            self.data.append("Title 1 \(Thread.current)")
//
//        }
//    }
//    
//    func addTitle2(){
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            self.data.append("Title 2 \(Thread.current)")
//
//        }
//  
//    }
    func addTitle1() async  {
        let title1 = "Title 1 \(Thread.isMainThread)"
        self.data.append(title1)
        try? await Task.sleep(for: .seconds(2))
        
        await MainActor.run {
            let title2 = "Title 2 \(Thread.isMainThread)"
            self.data.append(title2)
        }
    }
    
    func addSomething() async{
        data.append("Something")
    }
    
}

struct AsyncAwaitSample: View {
    @StateObject var viewModel = AsyncAwaitViewModel()
    var body: some View {
        List{
            ForEach(viewModel.data, id: \.self){data in
                Text(data)
                
            }
        }.onAppear{
            Task {
                await  viewModel.addTitle1()
            }
        }
        
    }
}

#Preview {
    AsyncAwaitSample()
}
