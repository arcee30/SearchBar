//
//  ContentView.swift
//  ArceeCard
//
//  Created by Arshaan Sayed on 6/24/22.
//

import SwiftUI


struct ContentView: View {
    //initialize textfield to have no initial input
    @State var searchText = ""
    @State var searching = false
    //create list of cars for the view
    let cars = [
        "Acura ", "Aston Martin ", "Audi ", "BMW ", "Bentley", "Bugatti", "Cadillac","Chevrolet ", "Chrysler","Dodge ", "Ferrari ", "Ford ","Genesis", "Henessey", "Honda ", "Hyundai", "Hoonigan", "Infiniti","Jaguar", "Jeep","Kia", "Koenigsegg", "Lamborghini", "Land Rover", "Lexus", "Lotus", "Maserati", "Mazda", "McLaren", "Mercedes Benz", "Mini","Nissan", "Pagani", "Porsche", "Renault", "Subaru", "SSC","Toyota", "Tesla", "Volkswagen", "Volvo", "Zenvo"
    ]
    
    var body: some View {
        NavigationView {
            //align searchbar and car elements vertically
            VStack(alignment: .leading) {
                //search bar code
                SearchBar(searchText: $searchText, searching: $searching)
                
                //list that displays all cars
                List {
                     ForEach(cars.filter({ (car: String) -> Bool in
                         return car.hasPrefix(searchText) || searchText == ""
                     }), id: \.self) { car in
                         Text(car)
                     }
                 }
                .listStyle(GroupedListStyle())
                //change navigation title based on search text
                .navigationTitle(searching ? "Searching" : "Car Brands")
                //cancel keyboard if user clicks cancel button
                .toolbar {
                    if searching {
                        Button("Cancel") {
                            searchText = ""
                            withAnimation {
                                searching = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                    }
                }
                //cancel keyboard if user starts scrolling down list mid-search
                .gesture(DragGesture()
                             .onChanged({ _ in
                                 UIApplication.shared.dismissKeyboard()
                             })
                 )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//implement search bar
struct SearchBar: View {
    //variables to get the text searched and whether or not user is currently searching
    @Binding var searchText: String
    @Binding var searching: Bool
    var body: some View {
        //overlay searchbar and gray rectangle
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
            //align magnifying glass icon and text field horizontally
            HStack {
                Image(systemName: "magnifyingglass")
                //textfield that checks when user starts typing to know when to pull and withdraw keyboard
                TextField("Search ..", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 50)
        .cornerRadius(13)
        .padding()
    }
}

//extension to dismiss keyboard when somethign is toggled
extension UIApplication {
      func dismissKeyboard() {
          sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
  }

