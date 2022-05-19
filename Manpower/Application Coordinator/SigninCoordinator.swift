//
//  SigninCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/29/22.
//

import UIKit
import RxSwift

class SigninCoordinator: BaseCoordinator {
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
    print("SigninCoordinator#deinit")
  }

  override func start() {
    let viewModel = SigninViewModel(authServiceable: authServiceable)
    let viewController = SigninViewController.instantiate(from: .onboarding)
    viewController.viewModel = viewModel
    viewModel.outputs.willGoBack.observe(on: MainScheduler.asyncInstance)
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController.popViewController(animated: true)
        self.didFinish()
      })
      .disposed(by: disposeBag)
    viewModel.outputs.signedinUser.filter { $0 != nil }
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] signedinUser in
        guard let self = self else { return }
        UserDefaults.standard.set(signedinUser!.id, forKey: "userId")
        self.goToDashboard()
        self.didFinish()
      })
      .disposed(by: disposeBag)

    navigationController.pushViewController(viewController, animated: true)
  }

  override func didFinish() {
    parentCoordinator?.free(coordinator: self)
  }

  func setupAuthRequiredServices() {
    employeeServiceable = EmployeeService(currentUser: currentUser!)
  }

  func goToDashboard() {
    NotificationCenter.default.post(name: NSNotification.Name("authChanged"), object: nil, userInfo: ["isAuth" : true])
  }
}
