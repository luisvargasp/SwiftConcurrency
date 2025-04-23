//
//  DoCatchTrySample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 22/04/25.
//

import SwiftUI
class DataFetcher  {
    let isActive: Bool = true
    func getData() -> (title : String? ,error : Error?) {
        if(!isActive){
            return (nil,URLError(.badServerResponse))
            
        }
        return ("New TEXT",nil)
    }
    func getData2() -> Result<String,Error>{
        if(!isActive){
            return .failure(URLError(.badServerResponse))
            
        }
        return .success("NEW TEXT SUCCESS")
    }
    
    func getData3() throws->String{
        throw URLError(.badServerResponse)

        if isActive {
            return "NEW TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
        
    }
    func getData4() throws->String{
        if isActive {
            return "FINAL TEXT"
        } else {
            throw URLError(.badServerResponse)
        }
        
    }
}
class DoCatchTryViewModel: ObservableObject {
    
    @Published var text: String = "Starting Text"
    let manager: DataFetcher = .init()
    
    func fetchTitle() {
        let result = manager.getData2()
        
        switch result {
        case .success(let text):
            self.text = text
        case .failure(let error):
            self.text = "\(error)"
        }
    }
    func fetchData() {
        do{
            let data = try?   manager.getData3()
            self.text = data ?? ""
            
            let finalData = try   manager.getData4()
            
            self.text = finalData
        }catch {
            self.text = "\(error)"
        }
       
    }
    
}

struct DoCatchTrySample: View {
    @StateObject private var viewModel = DoCatchTryViewModel()
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchData()
                
            }
    }
}

#Preview {
    DoCatchTrySample()
}
