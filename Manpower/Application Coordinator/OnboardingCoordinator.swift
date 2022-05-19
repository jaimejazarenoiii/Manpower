//
//  OnboardingCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/29/22.
//

import UIKit
import RxSwift

class OnboardingCoordinator: BaseCoordinator {
  var navigationController: UINavigationController
  var authServiceable: AuthServiceable
  var employeeServiceable: EmployeeServiceable?
  var currentUser: User?

  private let disposeBag = DisposeBag()

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    authServiceable = AuthService()
    super.init()
    guard currentUser != nil else { return }
    setupAuthRequiredServices()
  }

  deinit {
    print("OnboardingCoordinator#deinit")
  }

  override func start() {
    goToOnboarding()
  }

  override func didFinish() {
    parentCoordinator?.free(coordinator: self)
  }

  func setupAuthRequiredServices() {
    employeeServiceable = EmployeeService(currentUser: currentUser!)
  }

  func goToOnboarding() {
    let viewModel = OnboardingViewModel()
    let viewController = OnboardingViewController.instantiate(from: .onboarding)
    viewController.viewModel = viewModel

    viewModel.outputs.didTapSignin.filter { $0 != nil }.observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.goToSignin()
      }).disposed(by: disposeBag)

    viewModel.outputs.didTapSignup.filter { $0 != nil }.observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.goToSignup()
      }).disposed(by: disposeBag)

    navigationController.viewControllers = [viewController]
  }

  func goToSignin() {
    let coordinator = SigninCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    store(coordinator: coordinator)
    coordinator.start()
  }

  func goToSignup() {
    let coordinator = SignupCoordinator(navigationController: navigationController)
    coordinator.parentCoordinator = self
    store(coordinator: coordinator)
    coordinator.start()
  }
}

