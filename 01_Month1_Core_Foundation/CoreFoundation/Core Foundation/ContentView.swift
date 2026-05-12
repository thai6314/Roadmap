//
//  ContentView.swift
//  Core Foundation
//
//  Created by ThaiDV on 12/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var example: Example1? = .init()
    
    var body: some View {
        VStack {
            Button(action: run) {
                Text("Run")
                    .foregroundStyle(.white)
                    .padding(15)
                    .background(Color.cyan)
                    .clipShape(Capsule())
            }
        }
        .padding()
    }
    
    func run() {
        example = nil
    }
}
