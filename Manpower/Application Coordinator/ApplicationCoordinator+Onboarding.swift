//
//  ApplicationCoordinator+Onboarding.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

extension ApplicationCoordinator: OnboardingViewControllerDelegate {
    func didTapSignin(source: OnboardingViewController) {
        goToSignin()
    }

    func didTapSignup(source: OnboardingViewController) {
        goToSignup()
    }
}
