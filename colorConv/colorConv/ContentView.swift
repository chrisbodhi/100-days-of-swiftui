//
//  ContentView.swift
//  colorConv
//
//  Created by Chris Boette on 9/12/23.
//

import SwiftUI
import UIKit

enum ColorTypes: String, CaseIterable, Identifiable {
    case hex, rgb, hsl
    var id: Self { self }
}

func hexStringToColor(string hex: String) -> Color {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0

    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let red = Double((rgb & 0xFF0000) >> 16) / 255.0
    let green = Double((rgb & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgb & 0x0000FF) / 255.0

    return Color(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
}

func rgbStringToColor(string: String) -> Color {
    if (string.starts(with: "#")) {
        return Color.white
    }

    let vals = string
        .split(separator: ",")
        .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        .compactMap{ Int($0) }

    let red = Double(vals[0]) / 255.0
    let green = Double(vals[1]) / 255.0
    let blue = Double(vals[2]) / 255.0

    return Color(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)

}

func hslStringToColor(string: String) -> Color {
    if (string.starts(with: "#")) {
        return Color.white
    }

    let vals = string
        .replacingOccurrences(of: "%", with: "")
        .split(separator: ",")
        .compactMap {
            String($0).trimmingCharacters(in: .whitespacesAndNewlines)
        }

    let h = Double(vals[0]) ?? 100
    let s = (Double(vals[1]) ?? 100) / 100.0
    let l = (Double(vals[2]) ?? 100) / 100.0
    

    return Color(hue: h, saturation: s, brightness: l)
}

struct ContentView: View {
    @State private var colorDisplay: Color = Color.blue
    @State private var input = "#123456"
    @State private var colorType = ColorTypes.hex
    
    func setColor() {
        switch colorType {
        case .hex:
            self.colorDisplay = hexStringToColor(string: self.input)
        case .rgb:
            self.colorDisplay = rgbStringToColor(string: self.input)
        case .hsl:
            self.colorDisplay = hslStringToColor(string: self.input)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Color", text: $input) {
                        print($input)
                    }
                    Picker("Kind of color", selection: $colorType) {
                        ForEach(ColorTypes.allCases, id: \.self) {
                            Text($0.rawValue.uppercased())
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Insert the color to convert")
                }
                
                Section {
                    Button(action: setColor) {
                        HStack {
                            Text("See that Color")
                            Image(systemName: "arrow.down")
                        }
                    }
                }
                
                ZStack {
                    colorDisplay.edgesIgnoringSafeArea(.all)

                    Section {
                        Rectangle()
                            .fill(colorDisplay)
                            .frame(width: 900, height: 100)
                    }
                    .edgesIgnoringSafeArea(.all)
                }
                
                Section {
                    VStack {
                        Text("That Color in...")
                        Text("Hex: " + (colorDisplay.toHexString() ?? "oops"))
                        Text("RGB: " + (colorDisplay.toRgbString() ?? "oops"))
                        Text("HSL: " + (colorDisplay.toHslString() ?? "oops"))
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    func toHexString() -> String? {
        guard let components = UIColor(self).cgColor.components else {
            return nil
        }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])

        let hexString = String(format: "#%02lX%02lX%02lX",
                               lroundf(red * 255),
                               lroundf(green * 255),
                               lroundf(blue * 255))

        return hexString
    }
    
    func toRgbString() -> String? {
        guard let components = UIColor(self).cgColor.components else {
            return nil
        }

        let red = Float(components[0]) * 255.0
        let green = Float(components[1]) * 255.0
        let blue = Float(components[2]) * 255.0
        
        return String(format: "rgb(%.2f, %.2f, %.2f)", red, green, blue)
    }
    
    func toHslString() -> String? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        
        let lightness = (brightness + (saturation * brightness < 1 ? saturation * brightness : (1 - (1 - brightness) * (1 - saturation))) ) / 2


        return String(format: "HSL(%.1f, %.1f, %.1f)", hue, saturation, lightness)
    }
}
