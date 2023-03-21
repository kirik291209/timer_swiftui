import SwiftUI

enum ButtonType: String {
    case start = "start"
    case stop = "stop"
    case resume = "resume"
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var timer = Timer.TimerPublisher(interval: 1, runLoop: .main, mode: .common).autoconnect()
    
    var body: some View {
        VStack {
            if !self.viewModel.isStarted {
                TimerPicker(hour: $viewModel.hours, minutes: $viewModel.minutes, seconds: $viewModel.seconds)
                    .padding(.horizontal)
            } else {
                ZStack {
                    CountDownView(degrise: $viewModel.degrise)
                        .padding(.horizontal)
                    Text(self.viewModel.dateFormatter.getDate(hours: self.viewModel.hours, minutes: self.viewModel.minutes, seconds: self.viewModel.seconds))
                        .font(.custom("timerText", size: 60.0))
                }
            }
            HStack {
                cancelButton
                Spacer()
                startStopResumeButton
            }
            .padding(.horizontal)
        }
        .preferredColorScheme(.dark)
        .onReceive(timer) { timer in
            if self.viewModel.isStarted && !viewModel.isStopped {
                if self.viewModel.seconds > 0 {
                    self.viewModel.seconds -= 1
                } else if self.viewModel.minutes > 0 {
                    self.viewModel.seconds = 59
                    self.viewModel.minutes -= 1
                } else if self.viewModel.hours > 0 {
                    self.viewModel.hours -= 1
                    self.viewModel.minutes = 59
                    self.viewModel.seconds = 59
                } else {
                    self.viewModel.isStarted = false
                    self.viewModel.buttonType = .start
                }
                withAnimation() {
                    self.viewModel.degrise -= 1/viewModel.startedTime
                }
            }
        }
    }
    var cancelButton: some View {
        Button(action: {
            if self.viewModel.isStarted {
                self.viewModel.cancel()
            }
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                Circle()
                    .stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 85, height: 85)
                Text("cancel")
                    .foregroundColor(.white)
                    .font(.title3)
            }
            .foregroundColor(.gray)
        })
    }
    var startStopResumeButton: some View {
        Button(action: {
            if self.viewModel.buttonType == .start {self.viewModel.start()}
            else if self.viewModel.buttonType == .stop {self.viewModel.stop()}
            else if self.viewModel.buttonType == .resume {self.viewModel.resume()}
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                Circle()
                    .stroke(style: .init(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 85, height: 85)
                Text(self.viewModel.buttonType.rawValue)
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .foregroundColor(self.viewModel.buttonType == .stop ? .orange : .green)
        })
    }
}

struct CountDownView: View {
    
    @Binding var degrise: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: .init(lineWidth: 10, lineCap: .round, lineJoin: .round))
            Circle()
                .trim(from: 0, to: degrise)
                .stroke(style: .init(lineWidth: 10, lineCap: .square, lineJoin: .round))
                .foregroundColor(.orange)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}

struct TimerPicker: View {
    @Binding var hour: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
    var body: some View {
        HStack {
            Picker("hours", selection: $hour) {
                ForEach(0..<24) { hour in
                    Text("\(hour)").tag(hour)
                }
            }
            Text("hour")
            Picker("minutes", selection: $minutes) {
                ForEach(0..<60) { minutes in
                    Text("\(minutes)").tag(minutes)
                }
            }
            Text("min")
            Picker("hours", selection: $seconds) {
                ForEach(0..<60) { seconds in
                    Text("\(seconds)").tag(seconds)
                }
            }
            Text("sec")
        }
        .pickerStyle(.wheel)
    }
}

class DateForm: NSObject {
    func getDate(hours: Int, minutes: Int, seconds: Int) -> String {
        if hours > 0 {
            return convertDate(date: hours)+":"+convertDate(date: minutes)+":"+convertDate(date: seconds)
        } else {
            return convertDate(date: minutes)+":"+convertDate(date: seconds)
        }
    }
    private func convertDate(date: Int) -> String {
        return date > 9 ? "\(date)" : "0\(date)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
