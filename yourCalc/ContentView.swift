// yourCalc

import SwiftUI

enum CalcButton: String {
    //All the required buttons for the portrait orientation for yourCalc app
    //Need to add more more the landscape orientation
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "x"
    case equal = "="
    case clear = "C"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    //Currently went with the iPhone calcular app color scheme. It will change before the final submission as I play with colors
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
}

//Arithmetic operation
enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var value: Double = 0              //Default start value
    @State var storedValue: Double = 0          //Stores the value when "Operation" buttons are tapped
    @State var currentOperation: Operation = .none      //Sets the current operation to "none" before clicking any operation button
    @State var decimalEntered = false      // Boolean variable to keep track if the decimal was entered or not
    @State var digitsAfterDecimal: Int = 0 // Track the number of digits after the decimal point
    @State var errorMessage: String? = nil // Hold error message


    
    //Placing the buttons in the correct order
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    //View
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Error message or Text display
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .bold()
                        .font(.system(size: 70))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    HStack {
                        Spacer()
                        // Display the value if it's not nil, otherwise display "0"
                        if (self.value == 0 && !decimalEntered) {
                            Text("0")  // Display "0" when the value is exactly zero
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                                .bold()
                        } else {
                            // Format the value with the correct number of decimal places
                            Text(formatValue())
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }

                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 18) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 60))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }


    // Format the value with the correct number of decimal places
    private func formatValue() -> String {
        if !decimalEntered {
            return String(format: "%.0f", value) // Display integer value if decimal is not entered
        } else {
            let stringValue = String(value)
            return stringValue
        }
    }



    //Main Logic
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button != .equal {
                self.storedValue = self.value
                self.currentOperation = button == .add ? .add : button == .subtract ? .subtract : button == .multiply ? .multiply : .divide
                self.value = 0
                self.decimalEntered = false
            } else {
                let currentValue = self.value
                switch self.currentOperation {
                case .add: self.value = self.storedValue + currentValue
                case .subtract: self.value = self.storedValue - currentValue
                case .multiply: self.value = self.storedValue * currentValue
                case .divide:
                                    // Check for division by zero
                                    if currentValue != 0 {
                                        self.value = (self.storedValue) / currentValue
                                    } else {
                                        // Handle division by zero by setting error message
                                        self.errorMessage = "Error: Division by zero"
                                    }
                case .none: break
                }
                self.decimalEntered = false
            }
        case .clear:
            self.value = 0
            self.errorMessage = nil // Clear error message when clear button is tapped
            self.decimalEntered = false
            self.digitsAfterDecimal = 0
        case .decimal:
            // Only add decimal if the decimal point has not been entered yet
            if !self.decimalEntered {
                self.decimalEntered = true
            }
        case .negative:
            self.value *= -1
        case .percent:
            self.value /= 100
            //Assist from chatgpt for the default once I added the decimal
        default:
          let number = Double(button.rawValue)!
          if self.decimalEntered {
              self.digitsAfterDecimal += 1
            // Append the number as a fractional part.
              self.value += number / pow(10, Double(self.digitsAfterDecimal)) // Divide by 10 to shift the number one place to the right
          } else {
            // Append the number as part of the integer part of the value
            self.value = self.value * 10 + number
            self.digitsAfterDecimal = 0
          }
        }
    }

    

    //Setting up the grid to place the buttons in
    func buttonWidth(item: CalcButton) -> CGFloat {
        //Making the Zero button take up 2 cell space; every other button gets one cell
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
