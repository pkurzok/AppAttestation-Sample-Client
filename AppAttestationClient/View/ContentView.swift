//
//  ContentView.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import SwiftUI

// MARK: - ContentView

struct ContentView {
    @State private var viewModel = ViewModel()
}

// MARK: - View

extension ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .idle:
                    SampleListView(sampleData: viewModel.sampleData)
                }
            }
            .navigationTitle("Sample Data")
        }
        .task {
            await viewModel.fetchSampleData()
        }
    }
}

// MARK: - ContentView.ViewModel

extension ContentView {
    @Observable class ViewModel {
        enum State {
            case loading
            case idle
        }

        private let repository = SampleRepository()

        var state: State = .idle
        var sampleData: [Sample] = .init()

        func fetchSampleData() async {
            state = .loading
            sampleData = await repository.fetchSamples()
            state = .idle
        }
    }
}

#Preview {
    ContentView()
}
