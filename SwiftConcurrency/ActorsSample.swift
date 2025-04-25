//
//  ActorsSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 25/04/25.
//

import SwiftUI
class DataManager {
    private let queue: DispatchQueue = DispatchQueue(label: "com.lfvp.dataManager")
    static let shared = DataManager()
    private init() {
        
    }
    var data :[String] = []
    func getRandomData() -> String? {
    
        self.data.append(UUID().uuidString)
        print(Thread.current)
        
        return data.randomElement()
        
    }
    func getRandomData2( completion : @escaping  (_ title : String?) -> ())  {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completion( self.data.randomElement())
        }
        
    }
}
actor ActorDataManager {
    private let queue: DispatchQueue = DispatchQueue(label: "com.lfvp.dataManager")
    static let shared = ActorDataManager()
    private init() {
        
    }
    var data :[String] = []
    func getRandomData() -> String? {
    
        self.data.append(UUID().uuidString)
        print(Thread.current)
        
        return data.randomElement()
        
    }
    
}


struct HomeView: View {
    let manager: DataManager = .shared
    let actor: ActorDataManager = .shared
    @State private var  text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common,options: nil).autoconnect()
    var body: some View {
        ZStack{
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            Text(text)
                .font(.headline)
        }.onReceive(timer){_ in
            
            Task{
                if let  data =  await actor.getRandomData(){
                    await MainActor.run {
                        self.text = data
                    }
                    
                }
                
            }
            DispatchQueue.global(qos: .background).async{
//                manager.getRandomData2 { title in
//                    if let title = title {
//                        self.text=title
//                    }
//                }
                
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async{
                        
                        self.text = data
                    }
                 }
            }
            
            
        }
    }
}

struct BrowseView: View {
    let manager: DataManager = .shared
    let actor: ActorDataManager = .shared

    @State private var  text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common,options: nil).autoconnect()
    var body: some View {
        ZStack{
            Color.yellow.opacity(0.3)
                .ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer){_ in
            Task{
                
            }
            DispatchQueue.global(qos: .default).async{
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async{
                        
                        self.text = data
                    }
                 }
            }
            
        }
    }
}



struct ActorsSample: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection : $selectedTab) {
            
            Tab(value:0){
                HomeView()
            }label: {
                Image(systemName: "house")
            
                Text("Home")
            }
            Tab(value:1){
                BrowseView()
            }label: {
                Image(systemName: "magnifyingglass")
            
                Text("Browse")
            }
            
            
            
            
        }
    }
}

#Preview {
    ActorsSample()
}
