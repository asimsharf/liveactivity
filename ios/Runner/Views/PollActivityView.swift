//
//  PollActivityView.swift
//  Runner
//
//  Created by asimsharf on 16/11/2024.
//


import SwiftUI
import ActivityKit

struct PollActivityView: View {
    let context: ActivityViewContext<PollAttributes>

    var body: some View {
        VStack {
            Text(context.state.question)
                .font(.headline)
                .padding(.bottom, 8)

            ForEach(Array(context.state.options.enumerated()), id: \.0) { index, option in
                HStack {
                    Text(option)
                    Spacer()
                    Text("\(context.state.votes[index]) votes")
                }
                .padding(.vertical, 4)
            }
            .padding()
        }
        .padding()
    }
}
