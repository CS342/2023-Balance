//
//  NewTimerView.swift
//  Balance
//
//  Created by Gonzalo Perisset on 03/05/2023.
//

import SwiftUI

enum ChillType {
    case breathing
    case head
    case chest
    case shoulders
    case hands
    case knee
    case legs
}

enum BreathSteps {
    case inhale
    case holdInhale
    case exhale
    case holdExhale
}


struct Clock: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.custom("Nunito-Bold", size: 50))
                .foregroundColor(primaryColor)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

// swiftlint: disable type_body_length
struct NewTimerView: View {
    @State private var animationAmount: CGFloat = 1
    @State var counter: Int = 0
    @State var pause = false
    @State var shadowColor = Color.clear
    @State private var shadowScale: CGFloat = 0.45
    @State private var circleScale: CGFloat = 0.45
    @State var chillType: ChillType = .breathing
    @State var sliderValue: Float = 0.0
    @State var shouldTransition = false
    var navTitleText: String
    @State var subTitleText: String
    @State var stepTitleText = "Inhale"
    var countTo: Int = 120 // 4 minutes 120 - 2minutes
    @State var timer = Timer
        .publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
    @State var timerAnimation = Timer
        .publish(every: 2.0, on: .main, in: .common)
        .autoconnect()
    @State var scale: CGFloat = 1.0
    @State var breathStp: Int = 0
    
    var body: some View {
        ActivityLogContainer {
            ZStack {
                backgroudColor.edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    HeaderMenu(title: navTitleText)
                    Spacer()
                    subTitle
                    Spacer()
                    Clock(counter: counter, countTo: countTo)
                    Spacer()
                    progressAnimation
                    Group {
                        Spacer()
                        actionButton
                        Spacer()
                        sliderView
                        Spacer()
                    }
                }
                .onReceive(timer) { _ in
                    receiveAction()
                }
                .onAppear {
                    timerAnimation = Timer
                        .publish(every: (self.chillType == .breathing) ? 5.0 : 2.0, on: .main, in: .common)
                        .autoconnect()
                }
            }
        }
    }
    
    // swiftlint: disable vertical_parameter_alignment_on_call
    var sliderView: some View {
        VStack {
            Slider(
                value: $sliderValue,
                in: 0...Float(self.countTo)
            ) {
                Text("Speed")
            } minimumValueLabel: {
                Text(String(toMinutes()))
                    .font(.custom("Montserrat-Thin", size: 18))
                    .foregroundColor(darkGrayColor)
            } maximumValueLabel: {
                Text(counterToMinutes())
                    .font(.custom("Montserrat-Thin", size: 18))
                    .foregroundColor(darkGrayColor)
            } onEditingChanged: { _ in
                self.counter = Int(self.sliderValue)
            }
            .tint(primaryColor)
            .padding(.horizontal, 50)
        }
    }
    
    var insideView: some View {
        Group {
            switch self.chillType {
            case .breathing:
                breathAnimation
            case .head:
                headAnimation
            case .chest:
                centerAnimation
            case .shoulders:
                shouldersAnimation
            case .hands:
                handsAnimation
            case .knee:
                centerAnimation
            case .legs:
                centerAnimation
            }
        }
    }
    
    var subTitle: some View {
        Text(subTitleText)
            .font(.custom("Nunito-Bold", size: 25))
            .foregroundColor(violetColor)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.horizontal, 30.0)
            .background(.clear)
            .animation(.easeInOut(duration: 1), value: subTitleText)
    }
    
    var handsAnimation: some View {
        VStack(alignment: .leading, spacing: 0) {
            if shouldTransition {
                Image("hands1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("hands1")
            } else {
                Image("hands2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("hands2")
            }
        }
        .onReceive(timerAnimation) { _ in
            completed() ? self.timerAnimation.upstream.connect().cancel() : shouldTransition.toggle()
        }
        .animation(.easeInOut(duration: 0.5), value: shouldTransition)
    }
    
    var headAnimation: some View {
        VStack(alignment: .leading, spacing: 0) {
            if shouldTransition {
                Image("head1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("head1")
            } else {
                Image("head2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("head2")
            }
        }
        .onReceive(timerAnimation) { _ in
            completed() ? self.timerAnimation.upstream.connect().cancel() : shouldTransition.toggle()
        }
        .animation(.easeInOut(duration: 0.5), value: shouldTransition)
    }
    
    var shouldersAnimation: some View {
        VStack(alignment: .leading, spacing: 0) {
            if shouldTransition {
                Image("shoulders1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("shoulders1")
            } else {
                Image("shoulders2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .accessibilityLabel("shoulders2")
            }
        }
        .onReceive(timerAnimation) { _ in
            completed() ? self.timerAnimation.upstream.connect().cancel() : shouldTransition.toggle()
        }
        .animation(.easeInOut(duration: 0.5), value: shouldTransition)
    }
    
    var breathAnimation: some View {
        ZStack {
            Circle().fill(primaryColor)
                .frame(width: 60 * scale, height: 60 * scale)
                .shadow(color: primaryColor.opacity(0.8), radius: 20)
                .animation(.easeInOut(duration: 5), value: scale)
                .onAppear {
                    breath()
                }
                .onReceive(timerAnimation) { _ in
                    completed() ? self.timerAnimation.upstream.connect().cancel() : breath()
                }
            Text(stepTitleText)
                .font(.custom("Nunito-Bold", size: 25))
                .foregroundColor(.white)
                .frame(width: 80, height: 30)
                .shadow(color: .gray, radius: 1)
                .lineLimit(1, reservesSpace: true)
                .animation(.easeInOut(duration: 1), value: stepTitleText)
        }
    }
    
    var centerAnimation: some View {
        ZStack {
            Circle()
                .foregroundColor(shadowColor)
                .scaleEffect(shadowScale)
            Circle()
                .foregroundColor(primaryColor.opacity(0.8))
                .scaleEffect(circleScale)
            Image(systemName: "play.fill")
                .resizable()
                .foregroundColor(Color.white)
                .tint(Color.white)
                .frame(width: 40, height: 40)
                .opacity(0.9)
                .shadow(color: .white, radius: 20)
        }
        .onReceive(timerAnimation) { _ in
            completed() ? self.timerAnimation.upstream.connect().cancel() : animate()
        }
        .frame(width: 200, height: 200)
    }
    
    var actionButton: some View {
        HStack {
            backwardButton
            Spacer().frame(width: 25)
            pauseButton
            Spacer().frame(width: 25)
            forwardButton
        }
    }
    
    var forwardButton: some View {
        Button {
            self.counter += 15
        } label: {
            Image(systemName: "goforward.15")
                .resizable()
                .tint(lightGrayColor)
                .frame(width: 30, height: 30)
        }
    }
    
    var backwardButton: some View {
        Button {
            self.counter -= 15
        } label: {
            Image(systemName: "gobackward.15")
                .resizable()
                .tint(lightGrayColor)
                .frame(width: 30, height: 30)
        }
    }
    
    var pauseButton: some View {
        Button {
            if completed() {
                self.counter = 0
                timer = Timer
                    .publish(every: 1.0, on: .main, in: .common)
                    .autoconnect()
            }
            self.pause.toggle()
            if !pause {
                timerAnimation = Timer
                    .publish(every: (self.chillType == .breathing) ? 5.0 : 2.0, on: .main, in: .common)
                    .autoconnect()
            }
        } label: {
            if pause {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                    Image(systemName: "play")
                        .resizable()
                        .background(.white)
                        .tint(lightGrayColor)
                        .frame(width: 25, height: 30)
                }
            } else {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                    Image(systemName: "pause")
                        .resizable()
                        .background(.white)
                        .tint(lightGrayColor)
                        .frame(width: 25, height: 30)
                }
            }
        }
    }
    
    var progressAnimation: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 25)
                )
            Circle()
                .fill(Color.clear)
                .frame(width: 250, height: 250)
                .overlay(
                    Circle().trim(from: 0, to: progress())
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 25,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .foregroundColor(
                            (completed() ? primaryColor : primaryColor)
                        )
                        .animation(
                            Animation.linear(duration: 1), value: UUID()
                        )
                )
            insideView
        }
    }
    
    func breath() {
        switch breathStp {
        case 0:
            stepTitleText = "Inhale"
            scale = 3.0
            breathStp = 1
        case 1:
            stepTitleText = "Hold"
            scale = 3.0
            breathStp = 2
        case 2:
            stepTitleText = "Exhale"
            scale = 1.0
            breathStp = 3
        case 3:
            stepTitleText = "Hold"
            scale = 1.0
            breathStp = 0
        default:
            scale = 1.0
            breathStp = 0
            stepTitleText = "Inhale"
        }
    }
    
    func receiveAction() {
        if completed() {
            self.pause.toggle()
            timer.upstream.connect().cancel()
        } else {
            if pause {
                self.counter = self.counter
                timerAnimation.upstream.connect().cancel()
            } else {
                if self.counter < self.countTo {
                    self.counter += 1
                    self.sliderValue = Float(self.counter)
                }
            }
        }
    }
    
    func animate() {
        shadowColor = primaryColor.opacity(0.4)
        
        shadowScale = 0.45
        withAnimation(
            Animation
                .easeInOut(duration: 0.5)
        ) {
            circleScale = 0.25
            shadowScale = 0.5
        }
        withAnimation(
            Animation
                .easeInOut(duration: 0.5)
        ) {
            circleScale = 0.5
            shadowScale = 0.7
        }
        withAnimation(
            Animation
                .easeInOut(duration: 0.5)
        ) {
            circleScale = 0.7
            shadowScale = 1.0
        }
        withAnimation(
            Animation
                .easeInOut(duration: 0.5)
                .delay(2.0 * 0.7)
        ) {
            circleScale = 0.45
            shadowColor = .clear
        }
    }
    
    func completed() -> Bool {
        let value = progress() == 1
        return value
    }
    
    func progress() -> CGFloat {
        let value = (CGFloat(counter) / CGFloat(countTo))
        return value
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
    func toMinutes() -> String {
        let currentTime = countTo
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}

struct NewTimerView_Previews: PreviewProvider {
    static var previews: some View {
        NewTimerView(chillType: .shoulders, navTitleText: "Meditation", subTitleText: "Breathe deeply")
    }
}
