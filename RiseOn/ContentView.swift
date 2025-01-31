//
//  ContentView.swift
//  RiseOn
//
//  Created by Владислав Дробитько on 30/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
//            Color.black
//                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Image("logoRiseOn")
                    
                }
                .frame(width: 200, height: 100)
                
                
                VStack {
                    Text("Sunset Gradient")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient.gradientDarkGreen)
                        .cornerRadius(10)
                    
                    Text("Ocean Gradient")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient.gradientDarkGrey)
                        .cornerRadius(10)
                    
                    Text("Neon Gradient")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient.gradientLightGreen)
                        .cornerRadius(10)
                    Text("Neon Gradient")
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient.gradientLightGrey)
                        .cornerRadius(10)
                    
                    VStack(spacing: 6) {
                        Image("Logo")
                            
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 50)
                        Text("RISEON")
                            .font(.custom("Orbitron", size: 28))
                            .kerning(3)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    Text("RISEON")
                        .font(.custom("Orbitron", size: 28))
                        .kerning(2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient.gradientCard)
                        .cornerRadius(10)
                    
                    
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
