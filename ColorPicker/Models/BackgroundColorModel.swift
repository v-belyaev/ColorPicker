//
//  BackgroundColorModel.swift
//  ColorPicker
//
//  Created by Владимир Беляев on 20.12.2020.
//

import UIKit

final class BackgroundColorModel {
    private(set) var redValue: CGFloat = 0.0
    private(set) var greenValue: CGFloat = 0.0
    private(set) var blueValue: CGFloat = 0.0
    
    init() {
        setRandomValues()
    }
    
    func getCurrentColor() -> UIColor {
        UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
    }
    
    func getCurrentColorValues() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        return (redValue, greenValue, blueValue)
    }
    
    func setNewColorFrom(
        red: CGFloat? = nil,
        green: CGFloat? = nil,
        blue: CGFloat? = nil,
        with completion: (() -> Void)?
    ) {
        redValue = red ?? redValue
        greenValue = green ?? greenValue
        blueValue = blue ?? blueValue
        completion?()
    }
    
    private func setRandomValues() {
        redValue = CGFloat.random(in: 0.0...1.0)
        greenValue = CGFloat.random(in: 0.0...1.0)
        blueValue = CGFloat.random(in: 0.0...1.0)
    }
}
