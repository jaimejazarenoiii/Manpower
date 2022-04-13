//
//  ApplicationCoordinator+Signin.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

extension ApplicationCoordinator: SigninViewControllerDelegate {
    func didSigninSuccessfully(source: SigninViewController, signedinUser: User) {
        currentUser = signedinUser
        UserDefaults.standard.set(currentUser!.id, forKey: "userId")
        setupAuthRequiredServices()
        goToDashboard()
    }
}
