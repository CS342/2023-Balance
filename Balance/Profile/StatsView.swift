//
//  PersonalDataView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 28/04/2023.
//

import Charts
import SwiftUI

struct PostCount {
    var eventName: String
    var count: Int
}

struct StatsView: View {
    @Environment(\.dismiss)
    var dismiss
    var valuesData: [Double]
    var namesData: [String]
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                HeaderMenu(title: "User Stats")
                Spacer()
                if #available(iOS 17.0, *) {
                    chartView
                } else {
                    chartViewLib
                }
                Spacer()
            }
        }
    }
    
    var chartViewLib: some View {
        Chart {
            ForEach(namesData.indices, id: \.self) { index in
                BarMark(
                    x: .value("Event", namesData[index]),
                    y: .value("Count", valuesData[index])
                )
                .foregroundStyle(
                    by: .value("Scheme", namesData[index])
                )
            }
        }
        .padding(20)
        .chartXAxis(.hidden)
    }
    //        VStack {
    //                    GroupBox ( "Bar Chart - Step Count (x 1,000)") {
    //                        Chart(currentWeek) {
    //                            let stepThousands = Double($0.steps) / 1000.00
    //                            BarMark(
    //                                x: .value("Week Day", $0.weekday, unit: .day),
    //                                y: .value("Step Count", $0.steps)
    //                            )
    //                            .foregroundStyle(Color.orange)
    //                            .annotation(position: .overlay, alignment: .topLeading, spacing: 3) {
    //                                Text("\(stepThousands, specifier: "%.1F")")
    //                                    .font(.footnote)
    //                                    .foregroundColor(.white)
    //                            }
    //                        }
    //                        .chartYAxis(.hidden)
    //                        .chartXAxis {
    //                            AxisMarks (values: .stride (by: .day)) { value in
    //                                AxisValueLabel(format: .dateTime.weekday(),
    //                                               centered: true)
    //                            }
    //                        }
    //                    }
    //                    .frame(height: 500)
    //
    //                    Spacer()
    //                }
    //                .padding()
    //
    //        PieChartView(
    //            values: [1300, 500, 6, 3],
    //            names: ["Rent", "Transport", "Education", "2dsad"],
    //            formatter: {value in String(format: "$%.2f", value)})
    //        PieChartView(values: valuesData, names: namesData, formatter: { value in String(format: "$%.2f", value)})
    //    }
    
    @available(iOS 17.0, *)
    var chartView: some View {
        Chart(namesData.indices, id: \.self) { index in
            SectorMark(
                angle: .value("Count", valuesData[index]),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)
            .foregroundStyle(by: .value("Event", namesData[index]))
            .annotation(position: .overlay, alignment: .center) {
                VStack {
                    //                        Text(item.category)
                    //                           .font(.caption)
                    Text("\(valuesData[index], format: .number.precision(.fractionLength(0)))")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    Text("Events")
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding(30)
    }
}
