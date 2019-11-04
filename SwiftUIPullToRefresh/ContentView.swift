//
//  ContentView.swift
//  SwiftUIPullToRefresh
//
//  Created by Туков Анатолий on 04.11.2019.
//  Copyright © 2019 Туков Анатолий. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var reduxStore: ReduxStore<ReduxAppState, AppAction>
    @State private var alternate: Bool = true
    @State private var refred: Bool = false
    let transaction = Transaction(animation: .easeInOut(duration: 2.0))
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                //HeaderView(title: "Dog Roulette")
                RefreshableScrollView(height: 70, refreshing: self.$reduxStore.state.dog.loading) {
                    DogView(dog: self.reduxStore.state.dog.dog).padding(30).background(Color(UIColor.systemBackground))
                }.background(Color(UIColor.secondarySystemBackground))
            }.onReceive(reduxStore.publisher
                .eraseToAnyPublisher()
            ){ newValue in
                //print(newValue.dog.dog.name)
                if !self.refred {
                    self.reduxStore.send(.dog(action: .getNextDog))
                }
                self.refred.toggle()
                
            }
            .navigationBarTitle("\(self.reduxStore.state.dog.dog.name)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(sharedReduxStore)
    }
}


//

struct HeaderView: View {
    var title = ""
    
    var body: some View {
        VStack {
            //Color(UIColor.systemBackground).frame(height: 30).overlay(Text(self.title))
            Color(white: 0.5).frame(height: 3)
            .navigationBarTitle("Hello")
        }
    }
}

struct DogView: View {
    let dog: Dog
    
    var body: some View {
        VStack {
            Image(dog.picture, defaultSystemImage: "questionmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .padding(2)
                .overlay(Circle().strokeBorder(Color.black.opacity(0.1)))
                .shadow(radius: 3)
                .padding(4)
            
            Text(dog.name).font(.largeTitle).fontWeight(.bold)
            Text(dog.origin).font(.headline).foregroundColor(.blue)
            Text(dog.description)
                .lineLimit(nil)
                .frame(height: 1000, alignment: .top)
                .padding(.top, 20)
        }
    }
}

extension Image {
    init(_ name: String, defaultImage: String) {
        if let img = UIImage(named: name) {
            self.init(uiImage: img)
        } else {
            self.init(defaultImage)
        }
    }
    
    init(_ name: String, defaultSystemImage: String) {
        if let img = UIImage(named: name) {
            self.init(uiImage: img)
        } else {
            self.init(systemName: defaultSystemImage)
        }
    }
    
}
