//
//  ApplicationCoordinator+Dashboard.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/8/22.
//

import UIKit

extension ApplicationCoordinator: DashboardViewControllerDelegate {
    func didSignout(source: DashboardViewController) {
        UserDefaults.standard.set(nil, forKey: "userId")
        currentUser = nil
        goToOnboarding()
    }

    func willAddEmployee(source: DashboardViewController) {
        presentAddEmployeeForm(source: source)
    }

    func willEditEmployee(source: DashboardViewController, employee: Employee) {
        presentAddEmployeeForm(source: source, employee: employee)
    }
}
