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
    case clear = "AC"
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

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var value = "0"              //Default start value
    @State var runningNumber = 0        //Keeping the total
    @State var currentOperation: Operation = .none
    
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

                // Text display
                HStack {
                    Spacer()
                    Text(value)
                        //Styling
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()

                // Our buttons
                //for loop to set dimensions, size, and color of every button
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
    
    //Logic
    //Decimal button is missing some logic and isn't functioning as it should (Need to fix this!!)
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button != .equal {
                self.runningNumber = Int(self.value) ?? 0
                self.currentOperation = button == .add ? .add : button == .subtract ? .subtract : button == .multiply ? .multiply : .divide
                self.value = "0"
            } else {
                let currentValue = Int(self.value) ?? 0
                switch self.currentOperation {
                case .add: self.value = "\(self.runningNumber + currentValue)"
                case .subtract: self.value = "\(self.runningNumber - currentValue)"
                case .multiply: self.value = "\(self.runningNumber * currentValue)"
                case .divide: self.value = "\(self.runningNumber / currentValue)"
                case .none: break
                }
            }
        case .clear:
            self.value = "0"
        case .decimal:
            if !self.value.contains(".") {
                self.value += "."
            }
        case .negative:
            if !self.value.isEmpty && self.value != "0" {
                if self.value.prefix(1) == "-" {
                    self.value.remove(at: self.value.startIndex)
                } else {
                    self.value = "-" + self.value
                }
            }
        case .percent:
            if let currentValue = Double(self.value) {
                self.value = "\(currentValue / 100)"
            }
            
    
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
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
