//
//  TextFieldStatus.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

enum TextFieldStatus {
    case valid, invalid

    var borderColor: CGColor {
        switch self {
        case .valid: return UIColor.lightGray.cgColor
        default: return UIColor.red.cgColor
        }
    }
}
