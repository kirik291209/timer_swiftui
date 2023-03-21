import Foundation

class ViewModel: ObservableObject {
    @Published var seconds: Int = 0
    @Published var minutes: Int = 0
    @Published var hours: Int = 0
    @Published var isStarted: Bool = false
    @Published var degrise: CGFloat = 1.0
    @Published var buttonType: ButtonType = .start
    @Published var dateFormatter = DateForm()
    @Published var startedTime: CGFloat = 0.0
    @Published var isStopped: Bool = false
    func start() {
        if seconds > 0 || minutes > 0 || hours > 0 {
            self.isStarted.toggle()
            self.buttonType = .stop
            self.degrise = 1
            self.startedTime = CGFloat((hours*60*60)+(minutes*60)+seconds)
        }
    }
    
    func stop() {
        self.buttonType = .resume
        self.isStopped.toggle()
    }
    
    func resume() {
        self.buttonType = .stop
        self.isStopped.toggle()
    }
    
    func cancel() {
        self.minutes = 0
        self.seconds = 0
        self.hours = 0
        self.buttonType = .start
        self.isStarted.toggle()
    }
}
