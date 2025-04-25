//
//  GlobalActorSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
@globalActor struct MyGlobalActor{
    static let shared = DataManagerActor()
}
actor DataManagerActor {
    func getDataFromdb()  -> [String] {
        return ["1","2","3","4","5"]
    }
}
class GlobalActorViewModel: ObservableObject {
    let dataManager = MyGlobalActor.shared
    @Published var data: [String] = []
    
    @MyGlobalActor func getData() async {
        let data =    await dataManager.getDataFromdb()
        self.data = data
    }
}

struct GlobalActorSample: View {
    @StateObject private var viewModel = GlobalActorViewModel()
    var body: some View {
        ScrollView {
            VStack{
                ForEach(viewModel.data , id: \.self){data in
                    Text(data)
                        .font(.headline)
                }
            }
        }.task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorSample()
}
