//
//  MotionDetection.swift
//  Bubble Level
//
//  Created by Gabriel Marquez on 2023-08-03.
//

// Step 1: Your device has sensors such as accelerometers and gyroscopes that it uses to sense motion and orientation. The Core Motion framework gives you access to data from these and other sensors.
import CoreMotion
import UIKit

class MotionDetector: ObservableObject {
    // Step 2: You use a CMMotionManager object to get motion data from sensors, such as the accelerometer. It gathers information from the sensors and translates their data into values that you can understand.
    private let motionManager = CMMotionManager()

    //Step 3: The timer property stores a Timer instance. A timer waits for a period of time that you specify before running some code. The MotionDetector uses the timer to update its pitch, roll, and zAcceleration values at regular intervals, defined by the updateInterval property.
    private var timer = Timer()
    // Step 4: You can choose an update interval that makes sense for your app. For example, you’ll want a short update interval for the bubble level in this project because the interface presents real-time data as the device moves.
    private var updateInterval: TimeInterval

    // Step 5: These three properties store data for the tilt of your device in two dimensions (roll and pitch), as well as its vertical acceleration (zAcceleration).
    // Step 6: These properties have a @Published property wrapper, which means that any SwiftUI view that depends on their values updates when they change. You make a view dependent on a published property by referring to it in the view’s code. The BubbleLevel, LevelView, and OrientationDataView views use these properties, which enables them to update when the MotionDetector detects a change to the roll, pitch, or zAcceleration values.
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    @Published var zAcceleration: Double = 0

    // Step 7: This property stores code that runs when the MotionDetector updates its motion data. If you want to execute custom actions every time the motion data changes, you can put your own code into onUpdate in your instance of MotionDetector.
    var onUpdate: (() -> Void) = {}
    
    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    let notification = UIDevice.orientationDidChangeNotification

    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    // Step 8: This method starts updating the motion detector.
    func start() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) { [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp, .faceDown, .unknown:
                break
            default:
                self?.currentOrientation = UIDevice.current.orientation
            }
        }
        
        // Step 9: Always use isDeviceMotionAvailable to verify that motion data is available before you try to access it.
        if motionManager.isDeviceMotionAvailable {
            // Step 10 This method tells the CMMotionManager to start updating motion data.
            motionManager.startDeviceMotionUpdates()
            
            // Step 11: This code creates a new timer and schedules it to run. The updateInterval property tells the timer how long to wait between updates, and repeats is set to true so that the timer runs forever until you stop it. (If you pass false to repeats, the timer only runs once.)
            // Step 12: The block of code at the end of the line that reads { _ in is the start of a closure containing the code that the timer runs. The closure calls updateMotionData().
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Motion data isn't available on this device.")
        }
    }
    
    // Step 13: This method does the core work of the motion detector. It’s responsible for updating all the published properties with current data from the sensors, as well as calling the code in onUpdate.
    func updateMotionData() {
        // Step 14: The deviceMotion data may not be there in certain conditions. The way you can tell if the data exists is to try to assign it to a variable or constant using if let. If the motion data exists, it’s assigned to data and the code inside the braces runs. Otherwise, it skips the entire if statement.
        if let data = motionManager.deviceMotion {
            // Step 15: A CMDeviceMotion instance represents device motion, stored here in data. It has quite a few properties describing the input from the motion sensors.
            // Step 16: Use the attitude property to get the device’s tilt in three directions. You may be familiar with X, Y, and Z axes in 3D space. Pitch, roll, and yaw are numbers that describe rotation along those axes.
            (roll, pitch) = currentOrientation.adjustedRollAndPitch(data.attitude)
            // Step 17: Use the userAcceleration property to get the device’s acceleration after accounting for the downward pull of gravity. If it’s at rest, this number is 0. If it’s accelerating upward, the number is negative, and if it’s accelerating downward, the number is positive.
            zAcceleration = data.userAcceleration.z
            
            // Step 18: You run the code in onUpdate just as you’d call any function, with a set of parentheses following its name.
            onUpdate()
        }
    }

    // Step 19: This method stops updating the motion data. It does two important things:
    // Step 20: First, it tells the CMMotionManager to stop updating its values by calling stopDeviceMotionUpdates(), then it stops the timer by calling invalidate().
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: notification, object: nil)
        }
        orientationObserver = nil
    }
    
    // Step 21: This deinitializer runs when a MotionDetector instance is about to go away. It’s important to clean up here; otherwise the timer would continue to run even after the motion detector is gone.
    deinit {
        stop()
    }
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}

extension UIDeviceOrientation {
    func adjustedRollAndPitch(_ attitude: CMAttitude) -> (roll: Double, pitch: Double) {
        switch self {
        case .unknown, .faceUp, .faceDown:
            return (attitude.roll, -attitude.pitch)
        case .landscapeLeft:
            return (attitude.pitch, -attitude.roll)
        case .portrait:
            return (attitude.roll, attitude.pitch)
        case .portraitUpsideDown:
            return (-attitude.roll, -attitude.pitch)
        case .landscapeRight:
            return (-attitude.pitch, attitude.roll)
        @unknown default:
            return (attitude.roll, attitude.pitch)
        }
    }
}

