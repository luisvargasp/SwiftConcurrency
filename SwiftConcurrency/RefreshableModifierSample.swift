//
//  RefreshableModifierSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
@MainActor
class RefreshableViewModel: ObservableObject {
    @Published var items: [String] = []
    
    func loadData()  {
        Task{
            items = ["apple", "banana", "orange", "grape", "pineapple"].shuffled()
            
        }
        
    }
    
}

struct RefreshableModifierSample: View {
    @StateObject var viewModel = RefreshableViewModel()
    var body: some View {
        ScrollView{
            VStack{
                ForEach(viewModel.items, id: \.self){ fruit in
                    Text(fruit)
                        .font(.headline)
                }
            }
        }.onAppear{
            viewModel.loadData( )
        }.refreshable {
            viewModel.loadData()
        }
    }
}

#Preview {
    RefreshableModifierSample()
}
