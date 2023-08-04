//
//  OrientationDataView.swift
//  Bubble Level
//
//  Created by Gabriel Marquez on 2023-08-03.
//

import SwiftUI

// Step 1 The OrientationDataView displays the roll and pitch of your iPad as numbers. Roll is the degree of left and right tilt, and pitch is the degree of forward and backward tilt.
struct OrientationDataView: View {
    // Step 2: This property holds a MotionDetector instance. The motion detector senses changes in your device’s motion and provides that data for you to use in your code.
    // Step 3: Because detector is an observable object, any changes made to its published values cause SwiftUI to automatically update any views using those values. In this case, changes from the device’s sensors update the Text view with the latest values for the pitch and roll.
    @EnvironmentObject var detector: MotionDetector

    // Step 4: These two computed properties provide the strings used in the view. They take the roll or pitch value from the motion detector and format that number as a string with a fixed number of digits. The describeAsFixedLengthString() method is a custom method on the Double type. You can learn how it works in DoubleExtension.swift.
    var rollString: String {
        detector.roll.describeAsFixedLengthString()
    }
    // Step 4
    var pitchString: String {
        detector.pitch.describeAsFixedLengthString()
    }

    var body: some View {
        VStack {
            // Step 5: Here is the value for the roll of the device, presented as text.
            // Step 6: Because this view uses a published value from detector, SwiftUI updates it any time the motion detector’s roll value changes.
            Text("Horizontal: " + rollString)
            //Step 7: The .font modifier formats this Text view with a monospaced font. By default, a Text view uses a system font with proportional width, but that causes the text view to change its width as the numbers change.
            // Step 8: With a monospaced font, each character has the same width. (For example, the strings 1.01 and 3.14 have different widths with a proportional font like Helvetica or Times, but 1.01 and 3.14 have the same width with a monospaced font like Courier or Menlo.)
                .font(.system(.body, design: .monospaced))
            Text("Vertical: " + pitchString)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct OrientationDataView_Previews: PreviewProvider {
    @StateObject static private var motionDetector = MotionDetector(updateInterval: 0.01).started()
    
    static var previews: some View {
        OrientationDataView()
            .environmentObject(motionDetector)
    }
}

