//
//  ApplicationCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/6/22.
//

import UIKit
import RxSwift

class ApplicationCoordinator: BaseCoordinator {
  var navigationController: UINavigationController
  var authServiceable: AuthServiceable
  var employeeServiceable: EmployeeServiceable?
  var currentUser: User?
  private let disposeBag = DisposeBag()

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    authServiceable = AuthService()
    super.init()
    setupBindings()
  }

  override func start() {
    currentUser = authServiceable.getCurrentUser()
    currentUser != nil ? goToDashboard() : goToOnboarding()
  }

  private func setupBindings() {
    let center = NotificationCenter.default

    center.rx.notification(NSNotification.Name("authChanged"))
      .subscribe(onNext: { [weak self] notif in
        guard let self = self else { return }
        self.childCoordinators.removeAll()
        self.start()
      })
      .disposed(by: disposeBag)
  }

  func goToOnboarding() {
    let coordinator = OnboardingCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    store(coordinator: coordinator)
    coordinator.start()
  }

  func goToDashboard() {
    let coordinator = DashboardCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    store(coordinator: coordinator)
    coordinator.start()
  }

  override func didFinish() {}
}
