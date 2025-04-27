//
//  ObservableSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 27/04/25.
//

import SwiftUI


@Observable  class ObservableViewModel {
    @MainActor var text = "Starting Title"
    
    @MainActor func updateTitle() {
        text = "Updated Title"
    }
}

struct ObservableSample: View {
    
    @State var viewModel = ObservableViewModel()
    var body: some View {
        Text(viewModel.text)
            .task {
                viewModel.updateTitle()
            }
    }
}

#Preview {
    ObservableSample()
}
