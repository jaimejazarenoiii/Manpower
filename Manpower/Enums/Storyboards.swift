//
//  Storyboards.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import Foundation

enum Storyboards: String {
    case onboarding, dashboard

    var name: String {
        self.rawValue.capitalized
    }
}
