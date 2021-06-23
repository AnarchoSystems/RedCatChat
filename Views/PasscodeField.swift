//
//  PasscodeField.swift
//  RedCatChat
//
//  Created by Markus Pfeifer on 23.06.21.
//

import SwiftUI

// https://stackoverflow.com/questions/66030393/how-to-automatically-previous-textfield-when-clear-button-press-swiftui

public struct PasscodeField: View {
        
        var maxDigits: Int = 6
        
        @Binding var pin: String
        @State var showPin = true
        //@State var isDisabled = false
        
        
        var handler: (String) -> Void
        
        public var body: some View {
            VStack{
                ZStack {
                    pinDots
                    backgroundField
                }
                showPinStack
            }
            
        }
        
        private var pinDots: some View {
            HStack {
                Spacer()
                ForEach(0..<maxDigits) { index in
                    Image(systemName: self.getImageName(at: index))
                        .font(.system(size: 60))
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding(.trailing, -24)
            }
        }
        
        private var backgroundField: some View {
            let boundPin = Binding<String>(get: { self.pin },
                                           set: { newValue in
                self.pin = newValue
                self.submitPin()
            })
            
            return TextField("", text: boundPin, onCommit: submitPin)
               .accentColor(.clear)
               .foregroundColor(.clear)
        }
        
        private var showPinStack: some View {
            HStack {
                Spacer()
                if !pin.isEmpty {
                    showPinButton
                }
            }
            .frame(height: 100)
            .padding([.trailing])
        }
        
        private var showPinButton: some View {
            Button(action: {
                self.showPin.toggle()
            }, label: {
                self.showPin ?
                    Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
                    Image(systemName: "eye.fill").foregroundColor(.primary)
            })
        }
        
        private func submitPin() {
         
            if pin.count == maxDigits {
                handler(pin)
            }
            
            // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
            // max digits, we remove the additional characters and make a recursive call.
            if pin.count > maxDigits {
                pin = String(pin.prefix(maxDigits))
                submitPin()
            }
        }
        
        private func getImageName(at index: Int) -> String {
            if index >= self.pin.count {
                return "circle"
            }
            
            if self.showPin {
                return self.pin.digits[index].numberString + ".circle"
            }
            
            return "circle.fill"
        }
    }

    extension String {
        
        var digits: [Int] {
            var result = [Int]()
            
            for char in self {
                if let number = Int(String(char)) {
                    result.append(number)
                }
            }
            
            return result
        }
        
    }

    extension Int {
        
        var numberString: String {
            
            guard self < 10 else { return "0" }
            
            return String(self)
        }
    }
