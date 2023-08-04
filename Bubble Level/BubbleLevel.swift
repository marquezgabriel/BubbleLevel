//
//  BubbleLevel.swift
//  Bubble Level
//
//  Created by Gabriel Marquez on 2023-08-03.
//

import SwiftUI

// Step 1: This view displays the tilt of your device by drawing a circle within a larger circular boundary with crosshairs to indicate its centerpoint. When your device is level, the bubble rests at the center of the frame. Try tilting your device to see how the bubble moves.
struct BubbleLevel: View {
    // Step 2: This property holds a MotionDetector instance, which senses changes in your device’s motion. You can access this instance in your code to update the user interface as the motion data changes.
    // Step 3: Because detector is an observable object, any changes to its published values allows SwiftUI to automatically update any views using those values. In this case, you’ll update the bubble’s position.
    @EnvironmentObject var detector: MotionDetector

    // Step 4: This property represents the range of values the motion detector reports as you tilt the device (assuming you don’t turn it upside down). Negative values indicate a tilt to the left, and positive values indicate a tilt to the right. (You could assign the value 3.14 to this property, but Double.pi is convenient shorthand for the mathematical constant π, and it’s a closer approximation because it includes many digits of precision.)
    let range = Double.pi
    // Step 5: This is the size of the level display, both width and height. You can change this value to make the display larger or smaller.
    let levelSize: CGFloat = 300
    // Step 6: It’s useful to define and use constants like these for important values in your code, rather than using the values themselves. When you read the code, you’ll have a better idea of what it does than if you see a lot of numbers with no context.

    // Step 7: This property calculates the horizontal placement of the bubble using three steps.
    var bubbleXPosition: CGFloat {
        // Step 8: First, adjust the roll value from the detector so that it has a minimum of 0 and goes up to the value of π, and store the adjusted value in zeroBasedRoll. This helps with the next part of the calculation, which needs values greater than 0.
        let zeroBasedRoll = detector.roll + range / 2
        // Step 9: Then, use this adjusted value to calculate the roll as a fraction of the entire range of roll values, so that full tilt left is 0.0, flat is 0.5, and full tilt right is 1.0.
        let rollAsFraction = zeroBasedRoll / range
        // Step 10: Multiplying the fraction with the size of the level gives you the X position of the bubble.
        return rollAsFraction * levelSize
    } // Step 11: Because all of these calculations are hidden in a property, your view’s body code remains simple and readable.
    // Step 12: While you can write all of the code here in a longer mathematical expression, decomposing the code makes it easier to understand. (Can you imagine having to explain this code if it were written in one line?!)

    // Step 13: This property calculates the vertical position of the bubble in the same way that bubbleXPosition works.
    var bubbleYPosition: CGFloat {
        let zeroBasedPitch = detector.pitch + range / 2
        let pitchAsFraction = zeroBasedPitch / range
        return pitchAsFraction * levelSize
    }

    // Step 14: This property returns a vertical line that you use to draw the bubble level display. Because there are multiple identical vertical lines, you can use this property whenever you need one rather than repeating the more complex code inside it.
    var verticalLine: some View {
        Rectangle()
            .frame(width: 0.5, height: 40)
    }

    var horizontalLine: some View {
        Rectangle()
            .frame(width: 40, height: 0.5)
    }

    var body: some View {
        // Step 15: Here’s a circle with a gray foreground color that provides a visual boundary for the display.
        // Step 16: You can use a .frame modifier to give the circle a fixed width and height, which is important to draw the other components correctly.
        Circle()
            .foregroundStyle(Color.secondary.opacity(0.25))
            .frame(width: levelSize, height: levelSize)
            //Step 17: The .overlay modifier adds a view on top of the circle that occupies the same area.
            //Step 18: The overlay is useful here because it positions the level’s components relative to the circle they’re drawn in.
            .overlay(
                //Step 19: A ZStack view allows you to draw the components of the level over each other.
                ZStack {
                    
                    // Step 20: The first circle represents the bubble. Notice that the bubbleXPosition and bubbleYPosition values position the bubble inside the overlay view.
                    // Step 21: Because these properties use published values from MotionDetector, SwiftUI updates the bubble view’s position each time they change.
                    Circle()
                        .foregroundColor(.accentColor)
                        .frame(width: 50, height: 50)
                        .position(x: bubbleXPosition,
                                  y: bubbleYPosition)
                    
                    // Step 22: In the center are a smaller circle and a crosshair made of two lines: one horizontal and one vertical.
                    Circle()
                        .stroke(lineWidth: 0.5)
                        .frame(width: 20, height: 20)
                    verticalLine
                    horizontalLine
                    
                    // Step 23: There are four other lines on the edge of the frame of the bubble level display. You can use the .position modifier to move them relative to their default position at the center of the overlay view.
                    verticalLine
                        .position(x: levelSize / 2, y: 0)
                    verticalLine
                        .position(x: levelSize / 2, y: levelSize)
                    horizontalLine
                        .position(x: 0, y: levelSize / 2)
                    horizontalLine
                        .position(x: levelSize, y: levelSize / 2)
                }
            )
    }
}

struct BubbleLevel_Previews: PreviewProvider {
    @StateObject static var motionDetector = MotionDetector(updateInterval: 0.01).started()

    static var previews: some View {
        BubbleLevel()
            .environmentObject(motionDetector)
    }
}

