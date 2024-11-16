//
//  WorkoutActivityView.swift
//  Runner
//
//  Created by asimsharf on 16/11/2024.
//

import SwiftUI
import ActivityKit

struct WorkoutActivityView: View {
    let context: ActivityViewContext<WorkoutAttributes>

    var body: some View {
        VStack {
            Text(context.attributes.workoutType)
                .font(.title)
                .bold()
                .padding(.bottom, 8)

            HStack {
                VStack {
                    Text("Heart Rate")
                    Text("\(context.state.heartRate) BPM")
                        .bold()
                }
                VStack {
                    Text("Steps")
                    Text("\(context.state.steps)")
                        .bold()
                }
                VStack {
                    Text("Calories")
                    Text("\(context.state.caloriesBurned)")
                        .bold()
                }
            }
            .padding()

            ProgressView(value: context.state.goalProgress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding()
            
            Text("\(Int(context.state.goalProgress * 100))% of \(context.attributes.goal) completed")
                .font(.caption)
                .padding(.top, 4)
        }
        .padding()
    }
}
