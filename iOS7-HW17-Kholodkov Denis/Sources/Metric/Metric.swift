//
//  Metric.swift
//  iOS7-HW17-Kholodkov Denis
//
//  Created by Денис Холодков on 13.10.2022.
//

import UIKit

struct Metric {

// distance to top safeArea
    static let distanceTopToIndicator: CGFloat = 100
    static let distanceTopTotextField: CGFloat = 150
    static let distanceTopToLabelSecond: CGFloat = 200
    static let distanceTopToButtonStartAndStop: CGFloat = 260
    static let distanceTopToButtonColor: CGFloat = 310

// width, height, leading, trailing parameters
    static let buttoAndLabelHeight: CGFloat = 40
    static let trailingValue: CGFloat = -80
    static let leadingValue: CGFloat = 80
    static let leadingLabelSecond: CGFloat = 70
    static let trailingLabelSecond: CGFloat = -70
    static let trailingButtonStart: CGFloat = -200
    static let leadingButtonStop: CGFloat = 200
    static let heightButton: CGFloat = 30
    static let widthtButton: CGFloat = 150

// cornerRadius and color parameters
    static let cornerRadius: CGFloat = 16
    static let textFieldBackground = UIColor(red: 53/255.0,
                                               green: 193/255.0,
                                               blue: 148/255.0,
                                               alpha: 100)

    static let labelSecondTextColor = UIColor(red: 183/255.0,
                                              green: 154/255.0,
                                              blue: 194/255.0,
                                              alpha: 100)
}
