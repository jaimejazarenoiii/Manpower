//
//  ApplicationCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    var navigationController: UINavigationController
    var authServiceable: AuthServiceable
    var employeeServiceable: EmployeeServiceable?
    var currentUser: User?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        authServiceable = AuthService()
        guard currentUser != nil else { return }
        setupAuthRequiredServices()
    }

    func start() {
        let userId = UserDefaults.standard.string(forKey: "userId")
        guard userId != nil else { return goToOnboarding() }
        currentUser = authServiceable.getCurrentUser()!
        setupAuthRequiredServices()
        goToDashboard()
    }

    func setupAuthRequiredServices() {
        employeeServiceable = EmployeeService(currentUser: currentUser!)
    }
}
