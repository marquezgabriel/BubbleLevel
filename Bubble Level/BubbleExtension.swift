//
//  BubbleExtension.swift
//  Bubble Level
//
//  Created by Gabriel Marquez on 2023-08-03.
//

import Foundation

// Step 1: An extension is a way to make custom behavior for existing types. Declaring extension Double means you’re adding new capabilities to the Double type. Any time you use a Double value in your code, you can access anything defined in this extension.
extension Double {
    // Step 2: This method returns a string describing the value of a Double using a fixed number of digits. You can pass in the number of integer digits and fraction digits you want, or leave those arguments out for the default values of 2.
    func describeAsFixedLengthString(integerDigits: Int = 2, fractionDigits: Int = 2) -> String {
        // Step 3: The formatted() method operates on a number of basic types such as Date, Int, and Double, which are all commonly represented as strings in an app. Because there are so many ways to format these strings, the formatted() method gives you ways to customize how they’re represented. For example, does a number represent a percentage, or a simple value, or maybe a price?
        self.formatted(
            // Step 4: The argument to formatted() is a format style.
            // Step 5: The .number style gives you a string describing this Double value as a simple number, as opposed to a percentage or a price.
            .number
                // Step 6: The .number style has modifiers much like those for SwiftUI views.
                // Step 7: The .sign modifier lets you format the number so that it’s always preceded by a sign, even when the number is positive.
                // Step 8: The .precision modifier lets you specify exactly how many digits to use.
                .sign(strategy: .always())
                .precision(
                    .integerAndFractionLength(integer: integerDigits, fraction: fractionDigits)
                )
        )
    }
}

