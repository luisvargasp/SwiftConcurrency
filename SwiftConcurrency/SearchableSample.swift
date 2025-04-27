//
//  SearchableSample.swift
//  SwiftConcurrency
//
//  Created by FerVP on 26/04/25.
//

import SwiftUI
import Combine
struct Restaurant : Identifiable , Hashable {
    let id : String
    let title : String
    let cuisine :Cuisine
    
}
enum Cuisine : String {
    case american,italian,chinese,japanese,peruvian,turkish
}

class RestaurantManager {
    func getAllRestaurants() async throws -> [Restaurant] {
        
        return [
            Restaurant(id:"1",title: "Burger",cuisine: .american),
            Restaurant(id:"2",title: "Pasta",cuisine: .italian),
            Restaurant(id:"3",title: "Sushi",cuisine: .japanese),
            Restaurant(id:"4",title: "Pancakes",cuisine: .american),
            Restaurant(id:"5",title: "Spaghetti",cuisine: .italian),
            Restaurant(id:"6",title: "Ramen",cuisine: .japanese),
            Restaurant(id:"7",title: "Ceviche",cuisine: .peruvian),
            Restaurant(id:"8",title: "Manti",cuisine: .turkish),
            Restaurant(id:"9",title: "Kebab",cuisine: .turkish),
            Restaurant(id:"10",title: "Pizza",cuisine: .italian),
            Restaurant(id:"11",title: "Tacos",cuisine: .american),
            Restaurant(id:"12",title: "Doner Kebab",cuisine: .turkish),
            Restaurant(id:"13",title: "Sushi Rolls",cuisine: .japanese),
            Restaurant(id:"14",title: "Falafel",cuisine: .peruvian),
            
            ]
        
    }
}

@MainActor
class SearchableViewModel: ObservableObject {
    @Published private(set) var restaurants: [Restaurant] = []
    
    @Published private(set) var filteredRestaurants : [Restaurant] = []
    
    @Published var searchText : String = ""
    
    var isSearching : Bool {
        !searchText.isEmpty
    }
    var cancellables=Set<AnyCancellable>()
    @Published var searchScope:SearchScopeOption = .all
    
    @Published var allSearchScopes:[SearchScopeOption] = []
        
    
    enum SearchScopeOption : Hashable{
        case all
        case cuisine(option:Cuisine)
        var title:String{
            switch self {
            case .all:
                return "All"
            case .cuisine(option: let option):
                return option.rawValue.capitalized
            }
        }
        
    }
    init() {
        addSubscribers()
    }
    func addSubscribers() {
        $searchText
            .combineLatest($searchScope)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink{[weak self]   search,searchScope in
                self?.filterRestaurants(searchText: search,searchScope: searchScope)
                
              
            }
            .store(in: &cancellables)
    }
    private func filterRestaurants(searchText: String,searchScope:SearchScopeOption) {
        guard !searchText.isEmpty else {
            filteredRestaurants = restaurants
            self.searchScope = .all
            return
            
            
        }
        
        var restaurantInScope=restaurants
        switch searchScope {
        case .all:
            break
        case .cuisine(option: let cuisine):
            restaurantInScope = restaurants.filter({ restaurant in
                restaurant.cuisine == cuisine
            })
        }
        filteredRestaurants = restaurantInScope.filter {
            
            
            $0.title.lowercased().contains(searchText.lowercased())
            || $0.cuisine.rawValue .lowercased().contains(searchText.lowercased())
        }
        
        

    }
    
    
    
    
    let manager = RestaurantManager()
    
    func loadRestaurants() async {
        do {
            restaurants = try await manager.getAllRestaurants()
            let allCuisines = Set(restaurants.map{
                $0.cuisine
            })
            self.allSearchScopes = [.all]  + allCuisines.map{
                SearchScopeOption.cuisine(option: $0)
                
            }
        } catch {
            print("Error loading restaurants: \(error)")
        }
    }
    
}

struct SearchableSample: View {
    @StateObject var vm = SearchableViewModel()
    @State private var searchText: String = ""
    var body: some View {
        ScrollView{
            SearchChildView()
            VStack(spacing:20){
                ForEach(vm.filteredRestaurants){ restaurant in
                    NavigationLink(value: restaurant) {
                        
                        restaurantRow(restaurant: restaurant)
                    }
                    

                }
                
            }
        }.searchable(text: $vm.searchText,placement: .automatic,prompt: "Search Restaurants")
            .searchScopes( $vm.searchScope,scopes :{
                ForEach(vm.allSearchScopes,id:  \.self){scope in
                    Text(scope.title)
                        .tag(scope)
                    
                }
            })
            .searchSuggestions{
                Text("Pasta")
                    .searchCompletion("Pasta")
                
                Text("Hello world")
                Text("Hello world")
            }
        .navigationTitle("Restaurants")
        .task {
            await vm.loadRestaurants()
        }.navigationDestination(for: Restaurant.self, destination: { (restaurant) in
            Text(restaurant.title.uppercased())
            
        })
    }
    
    private func restaurantRow(restaurant: Restaurant) -> some View {
        
        VStack(alignment: .leading,spacing: 10){
            Text(restaurant.title)
                .font(.headline)
                .foregroundStyle(.black)
            Text(restaurant.cuisine.rawValue.capitalized)
                .font(.caption)
                .foregroundStyle(.black)

            
        }
        .frame(maxWidth: .infinity,alignment: .leading)
            .padding().background(Color.black.opacity(0.1))
            .padding(.horizontal)
        
    }
}

struct SearchChildView: View {
    @Environment(\.isSearching) private var isSearching
    var body: some View {
        Text("Search Child View is Searching : \(isSearching)")
    }
}

#Preview {
    NavigationStack {
    
        SearchableSample()
    }
}
