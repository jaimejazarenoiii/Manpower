//
//  ApplicationCoordinator+Signup.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

extension ApplicationCoordinator: SignupViewControllerDelegate {
    func didSignupSuccessfully(source: SignupViewController, createdUser: User) {
        currentUser = createdUser
        UserDefaults.standard.set(currentUser!.id, forKey: "userId")
        setupAuthRequiredServices()
        goToDashboard()
    }
}
