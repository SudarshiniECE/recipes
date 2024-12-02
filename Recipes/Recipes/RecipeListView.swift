//
//  RecipeListView.swift
//  Recipes
//
//  Created by Sudarshini Venugopal on 24/11/24.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}


import SwiftUI
import SDWebImageSwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        NavigationView {
            Group {
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                        Text(errorMessage)
                            .font(.headline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if viewModel.recipes.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        Text("No recipes available.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    List(viewModel.recipes) { recipe in
                        HStack {
                            WebImage(url: URL(string: recipe.photo_url_small ?? ""))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)

                            VStack(alignment: .leading) {
                                Text(recipe.name)
                                    .font(.headline)
                                Text(recipe.cuisine)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .navigationBarItems(trailing: refreshButton)
            .onAppear {
                Task {
                    await viewModel.loadRecipes()
                }
            }
        }
    }

    private var refreshButton: some View {
        Button(action: {
            Task {
                await viewModel.loadRecipes()
            }
        }) {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}


