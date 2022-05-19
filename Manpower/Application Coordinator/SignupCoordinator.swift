//
//  SignupCoordinator.swift
//  Manpower
//
//  Created by Jaime Jazareno III on 4/29/22.
//

import UIKit
import RxSwift

class SignupCoordinator: BaseCoordinator {
  var navigationController: UINavigationController
  var authServiceable: AuthServiceable
  var employeeServiceable: EmployeeServiceable?
  var currentUser: User?

  private let disposeBag = DisposeBag()

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    authServiceable = AuthService()
    super.init()
  }

  deinit {
    print("SignupCoordinator#deinit")
  }

  override func start() {
    let viewModel = SignupViewModel(authServiceable: authServiceable)
    let viewController = SignupViewController.instantiate(from: .onboarding)
    viewController.viewModel = viewModel

    viewModel.outputs.willGoBack
      .observe(on: MainScheduler.asyncInstance)
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.navigationController.popViewController(animated: true)
        self.didFinish()
      })
      .disposed(by: viewController.disposeBag)
    viewModel.outputs.createdUser.filter { $0 != nil }
      .observe(on: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] createdUser in
        guard let self = self else { return }
        UserDefaults.standard.set(createdUser!.id, forKey: "userId")
        self.goToDashboard()
      })
      .disposed(by: viewController.disposeBag)

    navigationController.pushViewController(viewController, animated: true)
  }

  override func didFinish() {
    parentCoordinator?.free(coordinator: self)
  }

  func goToDashboard() {
    NotificationCenter.default.post(name: NSNotification.Name("authChanged"), object: nil, userInfo: ["isAuth" : true])
  }
}
