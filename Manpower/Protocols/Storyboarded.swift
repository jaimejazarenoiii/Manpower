//
//  Storyboarded.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import Foundation

import UIKit

protocol Storyboarded {
    static func instantiate(from: Storyboards) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(from: Storyboards) -> Self {
        let fullName = NSStringFromClass(self)

        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: from.name, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
