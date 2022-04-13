//
//  ApplicationCoordinator+Navigation.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit

extension ApplicationCoordinator {
    func goToOnboarding() {
        let viewController = OnboardingViewController.instantiate(from: .onboarding)
        viewController.delegate = self
        navigationController.viewControllers = [viewController]
    }

    func goToSignin() {
        let viewModel = SigninViewModel(authServiceable: authServiceable)
        let viewController = SigninViewController.instantiate(from: .onboarding)
        viewController.viewModel = viewModel
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToSignup() {
        let viewModel = SignupViewModel(authServiceable: authServiceable)
        let viewController = SignupViewController.instantiate(from: .onboarding)
        viewController.viewModel = viewModel
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func goToDashboard() {
        let viewModel = DashboardViewModel(employeeServiceable: employeeServiceable!)
        let viewController = DashboardViewController.instantiate(from: .dashboard)
        viewController.viewModel = viewModel
        viewController.delegate = self
        DispatchQueue.main.async { [unowned self] () in
            self.navigationController.viewControllers = [viewController]
        }
    }

    func presentAddEmployeeForm(source: DashboardViewController, employee: Employee? = nil) {
        let viewModel = EmployeeFormViewModel(employeeServiceable: employeeServiceable!)
        let viewController = EmployeeFormViewController.instantiate(from: .dashboard)
        if let employee = employee {
            viewModel.inputs.set(employee: employee)
            viewModel.inputs.set(procedure: .edit)
        }
        viewController.viewModel = viewModel
        let navVc = UINavigationController(rootViewController: viewController)
        navVc.modalPresentationStyle = .fullScreen
        source.present(navVc, animated: true)
    }
}
