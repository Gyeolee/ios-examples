//
//  ContentView.swift
//  Semaphore
//
//  Created by Hangyeol on 2023/10/06.
//

import SwiftUI

fileprivate enum CountType {
    case increase, decrease, reset
}

struct ContentView: View {
    @State private var count: Int = 0
    @State private var semaphoreStatus: String = ""
    
    private let queue = DispatchQueue.global(qos: .userInteractive)
    private let semaphore = DispatchSemaphore(value: 1)
    
    var body: some View {
        VStack(spacing: 40) {
            Text("\(count)")
                .font(.title)
            
            HStack(spacing: 40) {
                Button(action: { count(.increase) }) {
                    Image(systemName: "plus")
                }
                
                Button(action: { count(.decrease) }) {
                    Image(systemName: "minus")
                }
            }
            
            Button(action: { count(.reset) }) {
                Image(systemName: "eraser")
            }
        }
        .padding()
    }
}

extension ContentView {
    private func count(_ type: CountType) {
        queue.async {
            semaphore.wait()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                semaphore.signal()
            }
            
            DispatchQueue.main.async {
                switch type {
                case .increase: count += 1
                case .decrease: count -= 1
                case .reset:    count = 0
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
