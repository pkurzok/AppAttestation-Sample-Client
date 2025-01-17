//
//  SampleListView.swift
//  AppAttestationClient
//
//  Created by Peter Kurzok on 16.01.25.
//

import SwiftUI

// MARK: - SampleListView

struct SampleListView {
    let sampleData: [Sample]
    let onRefresh: () async -> ()
}

// MARK: - View

extension SampleListView: View {
    var body: some View {
        List {
            ForEach(sampleData) { sample in
                HStack {
                    Rectangle()
                        .foregroundStyle(Color(hex: sample.hexColor).gradient)
                        .cornerRadius(10)
                        .frame(width: 50, height: 50)

                    VStack(alignment: .leading) {
                        Text(sample.title)

                        Text(sample.subtitle)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .refreshable {
            await onRefresh()
        }
    }
}

#Preview {
    SampleListView(sampleData: Sample.mockList, onRefresh: {})
}
